package com.skilldistillery.produce.services;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class PluImport {

//	private static String csv_location = "../../src/main/resources/static/PluCodes.csv";
	private static String csv_location = "plucodes.txt";

	public static void main(String[] args) {
		PluImport plu = new PluImport();
		plu.readCsv();
	}

	public void readCsv() {
		try (BufferedReader bufIn = new BufferedReader(new FileReader("allplucodes.txt"))) {
			String line;
			String splitBy = ",";
			String plu_code;
			String category;
			String commodity;
			String variety;

			while ((line = bufIn.readLine()) != null) {
				String[] row = line.split(splitBy);
				plu_code = "000000000" + row[0];
				category = row[1].replace("\"", "");
				commodity = row[2].replace("\"", "");
				variety = row[3].replace("\"", "");
				if (variety.contentEquals("Retailer Assigned")) {
					System.out.println(variety);
					continue;
				}
			}

		} catch (IOException e) {
			System.err.println(e);
		}
	}

}
