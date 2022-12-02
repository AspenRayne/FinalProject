package com.skilldistillery.produce.services;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.skilldistillery.produce.entities.Ingredient;
import com.skilldistillery.produce.repositories.IngredientRepository;
import com.skilldistillery.produce.services.api.KrogerAPIService;

@Service
public class PluImportService {
	
	@Autowired
	private IngredientRepository ingredientRepo;

	@Autowired
	private IngredientService ingredientService;
	
	@Autowired
	private KrogerAPIService apiService;
	
	private static String csv_location = "plucodes.txt";


	public void readCsv() {
		try (BufferedReader bufIn = new BufferedReader(new FileReader("allplucodes.txt"))) {
			String line;
			String splitBy = ",";
			String pluCode;
			String category;
			String commodity;
			String variety;
			List<String> pluCodeList = new ArrayList<>();
			List<Ingredient> ingredients = new ArrayList<>();
			pluCodeList.add("0000000003283");
//			int count = 0;
//			while ((line = bufIn.readLine()) != null) {
//				if (count == 0) {
//					count+=1;
//					continue;
//				}
//				count+=1;
//				String[] row = line.split(splitBy);
//				pluCode = "000000000" + row[0].replace("\"", "");
//				category = row[1].replace("\"", "");
//				commodity = row[2].replace("\"", "");
//				variety = row[3].replace("\"", "");
//				if (variety.contentEquals("Retailer Assigned")) {
//					continue;
//				}
//				pluCodeList.add(pluCode);
//			}
			for(String upc : pluCodeList) {
				Ingredient ingredient = apiService.ingredientDescription(upc);
				if (ingredient == null) {
					System.out.println("Ingredient not created: " + upc);
					continue;
				}
				ingredients.add(ingredient);
			}
			List<Ingredient> ingredientsDbUnified = ingredientService.categoryUnificationProcessor(ingredients);
			for(Ingredient ingredient : ingredientsDbUnified) {
				ingredientService.create(ingredient);
			}

		} catch (IOException e) {
			System.err.println(e);
		}
	}

}
