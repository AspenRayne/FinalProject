package com.skilldistillery.produce.services.api;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import org.apache.hc.client5.http.HttpResponseException;
import org.apache.hc.client5.http.fluent.Content;
import org.apache.hc.client5.http.fluent.Form;
import org.apache.hc.client5.http.fluent.Request;
import org.apache.hc.core5.http.HttpHeaders;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skilldistillery.apiSecrets.KrogerApiSecret;
import com.skilldistillery.produce.entities.Category;
import com.skilldistillery.produce.entities.ClientAccess;
import com.skilldistillery.produce.entities.Ingredient;
import com.skilldistillery.produce.repositories.CategoryRepository;
import com.skilldistillery.produce.repositories.ClientAccessRepository;
import com.skilldistillery.produce.repositories.IngredientRepository;

@Service
public class KrogerAPIService {

	@Autowired
	private ClientAccessRepository clientRepo;

	@Autowired
	private CategoryRepository categoryRepo;

	@Autowired
	private IngredientRepository ingredientRepo;

	private String encodedAuthString;
	private static String baseUrl = "https://api-ce.kroger.com/v1/";
	private String accessKey;

	/*
	 * API Utility
	 * 
	 * 
	 */
	private String base64EncodeSecrets() {
		String secrets = KrogerApiSecret.clientId + ":" + KrogerApiSecret.clientSecret;
		String encodedSecrets = "Basic " + Base64.getEncoder().encodeToString(secrets.getBytes());
		secrets = null;
		System.out.println(encodedSecrets);
		return encodedSecrets;
	}

	private String getClientAuthorization() {
		// Check ClientAuthorization Repository for most recent code
		ClientAccess clientAccess = clientRepo.findFirstByOrderByExpirationDesc();
		Instant instance = Instant.now();
		Timestamp now = Timestamp.from(instance);

		// If expired, request new code and store
		if (clientAccess != null && now.before(clientAccess.getExpiration())) {
			return clientAccess.getApikey();
		} else {
			try {
				return this.requestClientAuthorization();
			} catch (Exception e) {
				System.out.println(e);
			}
		}

		return null;

	}

	/*
	 * Public Query Methods
	 * 
	 * 
	 */

	@SuppressWarnings("unchecked")
	public JSONObject ingredientsLookup(String lookup, int pagination, boolean recommended) {
		String accessKey;
		if (this.accessKey == null) {
			accessKey = this.getClientAuthorization();
			if (accessKey == null) {
				return null;

			}
			this.accessKey = accessKey;
		}

		JSONObject response = new JSONObject();
		JSONArray recommendedIngredients = new JSONArray();
		if (recommended) {
			List<Ingredient> dbIngredients = ingredientRepo.findByNameContains(lookup);
			recommendedIngredients.add(dbIngredients);
		}
		response.put("recommendedIngredients", recommendedIngredients);

		JSONArray apiIngredients = new JSONArray();
		try {
			List<Ingredient> apiResults = this.requestProducts(lookup, pagination);
			apiIngredients.add(apiResults);
		} catch (HttpResponseException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		response.put("apiIngredients", apiIngredients);

		return response;
	}

	public Ingredient ingredientDescription(String upc) {
		String accessKey;
		if (this.accessKey == null) {
			accessKey = this.getClientAuthorization();
			if (accessKey == null) {
				return null;

			}
			this.accessKey = accessKey;
		}

		try {
			Ingredient ingredient = this.requestProductDetails(upc);
			return ingredient;
		} catch (IOException e) {
			return null;
		}
	}

	/*
	 * Kroger API
	 * 
	 * 
	 */

	private List<Ingredient> requestProducts(String lookup, int pagination) 
			throws IOException, HttpResponseException {
		
		String url = baseUrl + "products?filter.limit=50&filter.term=" 
				+ lookup.replace(" ", "%20")
				+ "&filter.start=" + pagination;
		Content response = Request.get(url).bodyForm(Form.form().build())
				.addHeader(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded")
				.addHeader(HttpHeaders.AUTHORIZATION, this.accessKey).execute().returnContent();
		JSONObject result = (JSONObject) JSONValue.parse(response.asString());
		JSONArray resultList = (JSONArray) result.get("data");
		
		List<Ingredient> products = new ArrayList<>();
		for (Object data : resultList) {
			Ingredient product = this.unpackKrogerProduct((JSONObject) data);
			if (product == null) {
				continue;
			}
			products.add(product);
		}
		return products;
	}

	private Ingredient requestProductDetails(String upc) throws IOException, HttpResponseException {
		String url = baseUrl + "products/" + upc;

		Content response = Request.get(url).bodyForm(Form.form().build())
				.addHeader(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded")
				.addHeader(HttpHeaders.AUTHORIZATION, this.accessKey).execute().returnContent();
		JSONObject result = (JSONObject) JSONValue.parse(response.asString());
		JSONObject data = (JSONObject) result.get("data");

		Ingredient ingredient = this.unpackKrogerProduct(data);
		return ingredient;
	}

	private String requestClientAuthorization() throws IOException {
		this.encodedAuthString = this.base64EncodeSecrets();
		String url = baseUrl + "connect/oauth2/token?grant_type=client_credentials" + "&scope=product.compact";

		Content response = Request.post(url).bodyForm(Form.form().build())
				.addHeader(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded")
				.addHeader(HttpHeaders.AUTHORIZATION, this.encodedAuthString).execute().returnContent();
		Object result = JSONValue.parse(response.asString());

		if (result instanceof JSONObject) {
			JSONObject obj = (JSONObject) result;
			Long expiration = (Long) obj.get("expires_in");
			String key = "Bearer " + obj.get("access_token").toString();
			System.out.println(key);
			ClientAccess newAccess = new ClientAccess(key, expiration);
			clientRepo.save(newAccess);
			return key;
		} else {
			// Throw error code
			return null;
		}

	}

	/*
	 * Unpack Data Objects
	 * 
	 */

	private Ingredient unpackKrogerProduct(JSONObject product) {
		Ingredient ingredient = new Ingredient();
		ingredient.setUpc(product.get("upc").toString());
		ingredient.setName(product.get("description").toString());
		JSONArray categoryArray = (JSONArray) product.get("categories");
		for (Object categoryName : categoryArray) {
			String name = categoryName.toString();
			ingredient.addCategory(new Category(name));
		}

		JSONArray perspectiveArray = (JSONArray) product.get("images");
		if (perspectiveArray != null) {
			for (Object perspectiveObj : perspectiveArray) {
				JSONObject perspectiveJSONObj = (JSONObject) perspectiveObj;
				if (perspectiveJSONObj.get("perspective").toString().equals("front")) {
					// loop sizes
					JSONArray sizeArray = (JSONArray) perspectiveJSONObj.get("sizes");
					for (Object sizeObj : sizeArray) {
						JSONObject sizeJSONObj = (JSONObject) sizeObj;
						if (sizeJSONObj.get("size").toString().equals("large")) {
							ingredient.setImgUrl(sizeJSONObj.get("url").toString());
							break;
						}
					}
					break;
				}
			}
			if (ingredient.getImgUrl() == null && perspectiveArray != null) {
				JSONObject perspectiveObj = (JSONObject) perspectiveArray.get(0);
				JSONArray sizeArray = (JSONArray) perspectiveObj.get("sizes");
				JSONObject imageObj = (JSONObject) sizeArray.get(1);

				ingredient.setImgUrl(imageObj.get("url").toString());
			}

		}
		return ingredient;
	}

}
