package com.skilldistillery.produce.services.api;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.Base64;
import java.util.List;

import org.apache.hc.client5.http.HttpResponseException;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.entity.UrlEncodedFormEntity;
import org.apache.hc.client5.http.fluent.Content;
import org.apache.hc.client5.http.fluent.Form;
import org.apache.hc.client5.http.fluent.Request;
import org.apache.hc.client5.http.fluent.Response;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.HttpHeaders;
import org.apache.hc.core5.http.io.entity.EntityUtils;
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

@Service
public class KrogerAPIService {

	@Autowired
	private ClientAccessRepository clientRepo;

	@Autowired
	private CategoryRepository categoryRepo;

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

	public List<Ingredient> ingredientsLookup() {
		String accessKey;
		if (this.accessKey == null) {
			accessKey = this.getClientAuthorization();
			if (accessKey == null) {
				return null;

			}
			this.accessKey = accessKey;
		}

		return null;
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
	private Ingredient requestProductDetails(String upc) throws IOException, HttpResponseException {
		String url = baseUrl + "products/" + upc;

		Content response = Request.get(url).bodyForm(Form.form().build())
				.addHeader(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded")
				.addHeader(HttpHeaders.AUTHORIZATION, this.accessKey).execute().returnContent();
		Object result = JSONValue.parse(response.asString());

		Ingredient ingredient = this.unpackKrogerProduct(result);
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

	private Ingredient unpackKrogerProduct(Object product) {
		Ingredient ingredient = new Ingredient();
		if (product instanceof JSONObject) {
			JSONObject obj = (JSONObject) product;
			JSONObject data = (JSONObject) obj.get("data");
			ingredient.setUpc(data.get("upc").toString());
			ingredient.setName(data.get("description").toString());
			JSONArray categoryArray = (JSONArray) data.get("categories");
			for (Object categoryName : categoryArray) {
				String name = categoryName.toString();
				ingredient.addCategory(new Category(name));
			}

			JSONArray perspectiveArray = (JSONArray) data.get("images");
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

		} else {
			return null;
		}
		return ingredient;

	}

}
