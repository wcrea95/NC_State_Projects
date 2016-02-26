/**
 * 
 */
package edu.ncsu.csc216.flix_2.inventory;

import java.io.FileInputStream;
import java.io.FileNotFoundException;

import java.util.Scanner;


import edu.ncsu.csc216.flix_2.list_util.MultiPurposeList;

/**
 * Creates and modifies a Movie database object
 * @author Will
 *
 */
public class MovieDB {
	
	/**
	 * MultiPurposeList of movies
	 */
	private MultiPurposeList<Movie> movies;

	/**
	 * Constructs a MovieDB object 
	 * @param fileName Name of the file containing the movie information 
	 */
	public MovieDB(String fileName) {
		movies = new MultiPurposeList<Movie>();
		try {
			readFromFile(fileName);
		} catch (FileNotFoundException e) {
			throw new IllegalArgumentException();
		}
	}
	
	/**
	 * Returns a string containing the movies display names separated by newlines
	 * @return temp String containing the movies display names separated by newlines
	 */
	public String traverse() {
		String temp = "";
		for(int i = 0; i < movies.size(); i++){
			temp += movies.lookAtItemN(i).getDisplayName() + "\n";
		}
		//System.out.println(temp);
		//System.out.println(movies.size());
		return temp;
	}
	
	/**
	 * Returns the movie at specified index
	 * @param index Index of the movie to be returned 
	 * @return Movie object at the specfied index in the movie database
	 */
	public Movie findItemAt(int index) {
		if(index < 0 || index >= movies.size()){
			throw new IllegalArgumentException();
		}
		
		return movies.lookAtItemN(index);

	}
	
	/**
	 * Reads in and populates the movie database
	 * @param fileName File name containing the movie information 
	 * @throws FileNotFoundException if the file does not exist
	 */
	private void readFromFile(String fileName) throws FileNotFoundException {
		Movie m = null;
		String holder = "";
		int count = 0;
			
		
		Scanner fileScanner = new Scanner(new FileInputStream(fileName));
		
		while (fileScanner.hasNextLine()) {
			try {
				holder = fileScanner.nextLine();
				
				m = new Movie(holder);
				
				insertInOrder(m, count);
				
			} catch (IllegalArgumentException e) {
				//if the exception is thrown, ignore the Course line.
				System.out.println(e.getMessage());
			}
			count++;
		}
		
		fileScanner.close();
	}
	
	/**
	 * Inserts the movies in alphabetical order 
	 * @param m Movie to be added
	 * @param count Count of the lines
	 */
	private void insertInOrder(Movie m, int count) {
		if(count == 0){
			movies.addItem(count, m);
			return;
		}
		
		
		
		for(int i = 0; i < movies.size(); i++){
			if(movies.lookAtItemN(i).compareToByName(m) > 0){
				movies.addItem(i , m);
				break;
			} else if (movies.lookAtItemN(i).compareToByName(m) < 0 && i == movies.size() - 1){
				movies.addToRear(m);
				break;
				//System.out.println("x1");
			}
		}
		
	}
}
