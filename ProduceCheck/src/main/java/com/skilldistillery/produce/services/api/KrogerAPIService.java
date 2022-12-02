package com.skilldistillery.produce.services.api;

import java.io.IOException;

import java.net.URL;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.Base64;
import java.util.List;

import org.apache.hc.client5.http.fluent.Content;
import org.apache.hc.client5.http.fluent.Form;
import org.apache.hc.client5.http.fluent.Request;
import org.apache.hc.core5.http.HttpHeaders;
import org.apache.hc.core5.http.ProtocolException;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.skilldistillery.apiSecrets.KrogerApiSecret;
import com.skilldistillery.produce.entities.ClientAccess;
import com.skilldistillery.produce.entities.Ingredient;
import com.skilldistillery.produce.repositories.ClientAccessRepository;

@Service
public class KrogerAPIService {
	
	@Autowired
	private ClientAccessRepository clientRepo;
	
	private String encodedAuthString;
	private static String baseUrl = "https://api-ce.kroger.com/v1/";
	
	/* 
	 * API Utility
	 * 
	 * 
	 * */
	private String base64EncodeSecrets(){
		String secrets = KrogerApiSecret.clientId + ":" +  KrogerApiSecret.clientSecret;
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
		if(clientAccess != null && now.before(clientAccess.getExpiration())) {
			return clientAccess.getKey();
		} else {
			try {
				return this.requestClientAuthorization();
			} catch(Exception e) {
				System.out.println(e);
			}
		}
		
		return null;
		
	}
	
	/* 
	 * Public Query Methods
	 * 
	 * 
	 * */
	
	
	public List<Ingredient> ingredientsLookup(){
		String accessKey = this.getClientAuthorization();
		if (accessKey == null) {
			return null;
		}
		
		
		return null;
	}
	
	public Ingredient ingredientDescription(String upc, boolean storeOnFind) {
		return null;
	}
	
	/* 
	 * Kroger API
	 * 
	 * 
	 * */
	
	
	private String requestClientAuthorization() throws IOException {
		this.encodedAuthString = this.base64EncodeSecrets();
		String url = baseUrl + "connect/oauth2/token?grant_type=client_credentials" 
					+ "&scope=product.compact";
		
		Content response = Request.post(url)
				.bodyForm(Form.form().build())
				.addHeader(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded")
				.addHeader(HttpHeaders.AUTHORIZATION, this.encodedAuthString)
				.execute().returnContent();
		Object result = JSONValue.parse(response.asString());
		
		if (result instanceof JSONObject) {
			JSONObject obj = (JSONObject) result;
			Long expiration = (Long) obj.get("expires_in");
			String key = "Bearer " + obj.get("access_token").toString();
			ClientAccess newAccess = new ClientAccess(key, expiration);
			clientRepo.save(newAccess);
			return key;
		}else {
			// Throw error code
			return null;
		}
		
	}
}
