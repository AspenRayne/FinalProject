package com.skilldistillery.produce.services;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class PluImport {

//	private static String csv_location = "../../src/main/resources/static/PluCodes.csv";
	private static String csv_location = "plucodes.txt";

//	public static void main(String[] args) {
//		PluImport plu = new PluImport();
//		plu.readCsv();
//	}

	public void readCsv() {
		try (BufferedReader bufIn = new BufferedReader(new FileReader("allplucodes.txt"))) {
			String line;
			String splitBy = ",";
			String pluCode;
			String category;
			String commodity;
			String variety;
			List<String> pluCodeList = new ArrayList<>();

			while ((line = bufIn.readLine()) != null) {
				String[] row = line.split(splitBy);
				pluCode = "000000000" + row[0];
				category = row[1].replace("\"", "");
				commodity = row[2].replace("\"", "");
				variety = row[3].replace("\"", "");
				if (variety.contentEquals("Retailer Assigned")) {
					System.out.println(variety);
					continue;
				}
				pluCodeList.add(pluCode);
			}
//			KrogerAPIService apiService = new KrogerAPIService();
//			for(String upc : pluCodeList) {
//				apiService.ingredientDescription(upc, true);
//			}

		} catch (IOException e) {
			System.err.println(e);
		}
	}

}
