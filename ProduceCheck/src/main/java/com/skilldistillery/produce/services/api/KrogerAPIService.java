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
import com.skilldistillery.produce.entities.Company;
import com.skilldistillery.produce.entities.Ingredient;
import com.skilldistillery.produce.entities.Store;
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
	private Timestamp accessKeyExpiration;

	/*
	 * API Utility
	 * 
	 * 
	 */
	private String base64EncodeSecrets() {
		String secrets = KrogerApiSecret.clientId + ":" + KrogerApiSecret.clientSecret;
		String encodedSecrets = "Basic " + Base64.getEncoder().encodeToString(secrets.getBytes());
		secrets = null;
		return encodedSecrets;
	}

	private void setClientAuthorization() {
		Timestamp now = Timestamp.from(Instant.now());
		if (this.accessKeyExpiration != null && this.accessKey != null) {
			if (now.before(this.accessKeyExpiration)) {
				return;
			}
		}
		
		// Check ClientAuthorization Repository for most recent code
		ClientAccess clientAccess = clientRepo.findFirstByOrderByExpirationDesc();

		// If expired, request new code and store
		if (clientAccess != null && now.before(clientAccess.getExpiration())) {
			this.accessKey = clientAccess.getApikey();
			this.accessKeyExpiration = clientAccess.getExpiration();
		} else {
			try {
				ClientAccess access = this.requestClientAuthorization();
				this.accessKey = access.getApikey();
				this.accessKeyExpiration = access.getExpiration();
			} catch (Exception e) {
				System.out.println(e);
			}
		}

	}

	/*
	 * Public Query Methods
	 * 
	 * 
	 */

	@SuppressWarnings("unchecked")
	public JSONObject ingredientsLookup(String lookup, int pagination, boolean recommended, int locationId) {
		this.setClientAuthorization();

		JSONObject response = new JSONObject();
		if (recommended) {
			List<Ingredient> dbIngredients = ingredientRepo.findByNameContains(lookup);
			response.put("recommendedIngredients", dbIngredients);
		}
		

		try {
			JSONObject apiResults = this.requestProducts(lookup, pagination, locationId);
			response.put("apiData", apiResults.get("data"));
			response.put("pagination", apiResults.get("pagination"));
		} catch (HttpResponseException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return response;
	}

	public Ingredient ingredientDescription(String upc) {
		this.setClientAuthorization();

		try {
			Ingredient ingredient = this.requestProductDetails(upc);
			return ingredient;
		} catch (IOException e) {
			return null;
		}
	}

	public List<Store> storeLookup(String zipcode) {
		this.setClientAuthorization();
		List<Store> stores;
		try {
			stores = this.requestLocations(zipcode);
			return stores;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<JSONObject> availabilityCheck(int storeId, List<String> productIds) {
		this.setClientAuthorization();
		List<JSONObject> responseData = new ArrayList<>();
		for (String productId : productIds) {
			try {
				JSONObject productStats = this.requestProductStats(storeId, productId);
				responseData.add(productStats);
			} catch (IOException e) {
				// TODO advanced error handling instead of breaking the loop
				e.printStackTrace();
				return null;
			}
		}
		
		return responseData;
	}
	

	/*
	 * Kroger API
	 * 
	 * 
	 */

	@SuppressWarnings("unchecked")
	private JSONObject requestProducts(String lookup, int pagination, int locationId) throws IOException, HttpResponseException {
		JSONObject dataResponse = new JSONObject();
		String url;
		if (locationId > 0) {
			url = baseUrl + "products?filter.limit=50" 
					+ "&filter.term=" + lookup.replace(" ", "%20") 
					+ "&filter.start=" + pagination
					+ "&filter.fulfillment=ais"
					+ "&filter.locationId=" + locationId;
		} else {
			url = baseUrl + "products?filter.limit=50" 
					+ "&filter.term=" + lookup.replace(" ", "%20") 
					+ "&filter.start=" + pagination;
		}
		System.out.println(url);
		
		Content response = Request.get(url).bodyForm(Form.form().build())
				.addHeader(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded")
				.addHeader(HttpHeaders.AUTHORIZATION, this.accessKey).execute().returnContent();
		JSONObject result = (JSONObject) JSONValue.parse(response.asString());
		JSONArray resultList = (JSONArray) result.get("data");

		// Pagination Details
		JSONObject meta = (JSONObject) result.get("meta");
		dataResponse.put("pagination", (JSONObject) meta.get("pagination"));

		List<Ingredient> products = new ArrayList<>();
		for (Object data : resultList) {
			Ingredient product = this.unpackKrogerProduct((JSONObject) data);
			if (product == null) {
				continue;
			}
			products.add(product);
		}
		// Data
		dataResponse.put("data", products);

		return dataResponse;
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
	
	
	private JSONObject requestProductStats(int storeId, String upc) throws IOException {
		String url = baseUrl + "products/" + upc 
				+ "?filter.locationId=" + storeId;

		Content response = Request.get(url).bodyForm(Form.form().build())
				.addHeader(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded")
				.addHeader(HttpHeaders.AUTHORIZATION, this.accessKey).execute().returnContent();
		JSONObject result = (JSONObject) JSONValue.parse(response.asString());
		JSONObject data = (JSONObject) result.get("data");
		
		JSONObject stats = this.unpackProductStats(data);
		
		return stats;
	}
	

	private ClientAccess requestClientAuthorization() throws IOException {
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
			newAccess = clientRepo.save(newAccess);
			return newAccess;
		} else {
			// Throw error code
			return null;
		}

	}

	private List<Store> requestLocations(String zipcode) throws IOException {
		String url = baseUrl + "locations?filter.zipCode.near=" + zipcode;

		Content response = Request.get(url).bodyForm(Form.form().build())
				.addHeader(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded")
				.addHeader(HttpHeaders.AUTHORIZATION, this.accessKey).execute().returnContent();
		JSONObject result = (JSONObject) JSONValue.parse(response.asString());
		JSONArray dataArray = (JSONArray) result.get("data");
		List<Store> stores = new ArrayList<>();
		for (Object data : dataArray) {
			Store store = this.unpackKrogerStore((JSONObject) data);
			if (store != null) {
				stores.add(store);
			}
		}

		return stores;
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

	private Store unpackKrogerStore(JSONObject storeData) {
		Store store = new Store();
		store.setLocationId(Integer.parseInt(storeData.get("locationId").toString()));
		JSONObject address = (JSONObject) storeData.get("address");
		store.setStreet1(address.get("addressLine1").toString());
		store.setCity(address.get("city").toString());
		store.setState(address.get("state").toString());
		store.setZipCode(address.get("zipCode").toString());

		Company company = new Company();
		company.setName(storeData.get("chain").toString());

		store.setCompany(company);
		return store;

	}
	
	@SuppressWarnings("unchecked")
	private JSONObject unpackProductStats(JSONObject data) {
		JSONObject stats = new JSONObject();
		stats.put("upc", data.get("upc").toString());
		stats.put("aisles", (JSONArray) data.get("aisleLocations"));
		stats.put("inStore", false);
		stats.put("price", null);
		stats.put("salePrice", null);
		stats.put("availability", null);
		
		JSONArray items = (JSONArray) data.get("items");
		if (items.size() > 0) {
			JSONObject first = (JSONObject) items.get(0);
			JSONObject fulfillment = (JSONObject) first.get("fulfillment");
			boolean instore = false;
			if (fulfillment != null) {
				instore = Boolean.parseBoolean(fulfillment.get("inStore").toString());
			}
			stats.put("inStore", instore);
			
			JSONObject priceObj = (JSONObject) first.get("price");
			Double price = null;
			Double salePrice = null;
			if (priceObj != null) {
				price = Double.parseDouble(priceObj.get("regular").toString());
				salePrice = Double.parseDouble(priceObj.get("promo").toString());
			}
			stats.put("price", price);
			stats.put("salePrice", salePrice);
			
			// Stock level
			JSONObject inventory = (JSONObject) first.get("inventory");
			String stockInfo = null;
			if (inventory != null) {
				stockInfo = inventory.get("stockLevel").toString();
			}
			stats.put("availability", stockInfo);
			
		} 
		
		return stats;
	}

}
