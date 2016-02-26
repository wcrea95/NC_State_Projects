/**
 * 
 */
package edu.ncsu.csc216.flix_2.inventory;

/**
 * Creates and modifies a Movie object
 * @author Will
 *
 */
public class Movie {

	/**
	 * Name of the movie
	 */
	private String name;
	
	/**
	 * Number of the movies available 
	 */
	private int inStock;
	
	/**
	 * Constructs a Movie using information that is passed in
	 * @param movieInfo Stock and Name of the movie separated by a whitespace
	 */
	public Movie(String movieInfo) {
		String[] tokens = movieInfo.split("[ ]");
		
		int stock = Integer.parseInt(tokens[0]);
		if(stock < 0){
			stock = 0;
		}
		
		String movieName = "";
		for(int i = 1; i < tokens.length; i++){
		
			movieName += tokens[i];
			
			if(i < tokens.length - 1){
				movieName += " ";
			}
		}
		
		this.name = movieName.trim();
		this.inStock = stock;
	}
	
	/**
	 * Returns the name of the movie
	 * @return name of the Movie
	 */
	public String getName() {
		return name;
	}
	
	/**
	 * Returns the display name of the movie
	 * @return name of the Movie plus an extra string if no movies are currently in stock
	 */
	public String getDisplayName() {
		
		if(inStock == 0){
			return name + " (currently unavailable)";
		}
		
		return name;
	}
	
	/**
	 * Compares movie names lexicographically 
	 * @param m Movie to be compared to
	 * @return A negative integer if current movie precedes the passed in movie
	 *         A positive integer if the current movie is in front of the passed in movie
	 *         0 if movie names are the same
	 */
	public int compareToByName(Movie m) {
		String tempThis = "";
		String tempPass = "";
		
		if(this.getName().contains("A ")){
			tempThis = this.getName().replace("A ", "");
		} else if (this.getName().contains("An ")) {
			tempThis = this.getName().replace("An ", "");
		} else if (this.getName().contains("The ")){
			tempThis = this.getName().replace("The ", "");
		} else {
			tempThis = this.getName();
		}
		
		if(m.getName().contains("A ")){
			tempPass = m.getName().replace("A ", "");
		} else if (m.getName().contains("An ")) {
			tempPass = m.getName().replace("An ", "");
		} else if (m.getName().contains("The ")){
			tempPass = m.getName().replace("The ", "");
		} else {
			tempPass = m.getName();
		}
		
		
		
		//System.out.println(tempThis);
		//System.out.println(tempPass);
		return tempThis.compareToIgnoreCase(tempPass);
	}
	
	/**
	 * Determines whether any of the movie is in stock
	 * @return true if stock not equal to 0
	 */
	public boolean isAvailable() {
		return inStock != 0;
	}
	
	/**
	 * Adds one to the stock of the movie
	 */
	public void backToInventory() {
		inStock++;
		
	}
	
	/**
	 * Removes one from the stock of the movie
	 */
	public void removeOneCopyFromInventory() {
		if(!isAvailable()){
			throw new IllegalStateException("No copy of this movie currently available.");
		}
		inStock--;
		//System.out.println(inStock);
		
	}
}
