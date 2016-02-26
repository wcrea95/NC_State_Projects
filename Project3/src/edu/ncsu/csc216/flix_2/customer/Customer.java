/**
 * 
 */
package edu.ncsu.csc216.flix_2.customer;

import edu.ncsu.csc216.flix_2.inventory.Movie;
import edu.ncsu.csc216.flix_2.list_util.MultiPurposeList;

/**
 * Creates and modifies a Customer object
 * @author Will
 *
 */
public class Customer {

	/**
	 * Customer's username
	 */
	private String id;
	
	/**
	 * Customer's password
	 */
	private String password;
	
	/**
	 * How many movies the Customer is allowed at home
	 */
	private int maxAtHome;
	
	/**
	 * How many movies the Customer currently has at home
	 */
	private int nowAtHome;
	
	/**
	 * List of movies Customer has at home
	 */
	private MultiPurposeList<Movie> atHomeQueue;
	
	/**
	 * List of movies Customer has reserved
	 */
	private MultiPurposeList<Movie> reserveQueue;
	
	/**
	 * Constructs a Customer object
	 * @param id Username of the Customer account
	 * @param password Password of the Customer account
	 * @param max Maximum number of movies the Customer is allowed at home
	 */
	public Customer(String id, String password, int max) {
		
		if(id == null || password == null || id.trim().length() == 0 || password.trim().length() == 0 ){
			throw new IllegalArgumentException();
		}
		this.id = id;
		this.password = password;
		
		if(max < 0){
			this.maxAtHome = 0;
		} else {
			this.maxAtHome = max;
		}
		
		this.nowAtHome = 0;
		
		atHomeQueue = new MultiPurposeList<Movie>();
		reserveQueue = new MultiPurposeList<Movie>();
		
	}
	
	/**
	 * Checks to see if the passed in string is equal to the customer password
	 * @param unverified Password typed in to be checked against actual password
	 * @return True if password equals unverified
	 */
	public boolean verifyPassword(String unverified) {
		
		return password.equals(unverified.trim());
	}
	
	/**
	 * Returns id of the Customer
	 * @return Id of the customer after trimming whitespace
	 */
	public String getId() {
		return id.trim();
	}
	
	/**
	 * Lexicographic comparison of two customer names
	 * @param c Customer to be compared to
	 * @return Positive integer if id of current customer comes after that of the passed in customer
	 *         Negative integer if id of the current customer precedes that of the passed in customer
	 *         0 if Id's are equal
	 */
	public int compareToByName(Customer c) {
		return this.getId().trim().compareToIgnoreCase(c.getId().trim());
	}
	
	/**
	 * IDK WHAT THIS DOES TO BE HONEST BUT IT WORKS SO...
	 */
	public void login() {
		//IDK WHAT THIS DOES
	}
	
	/**
	 * Traverses the reserve queue
	 * @return A string corresponding to the movies in the reserve queue separated by newlines
	 */
	public String traverseReserveQueue() {
		String temp = "";
		for(int i = 0; i < reserveQueue.size(); i++){
			temp += reserveQueue.lookAtItemN(i).getName() + "\n";
		}
	
		return temp;
	}
	
	/**
	 * Traverses the atHome queue
	 * @return A string corresponding to the movies in the atHome queue separated by newlines
	 */
	public String traverseAtHomeQueue() {
		String temp = "";
		for(int i = 0; i < atHomeQueue.size(); i++){
			temp += atHomeQueue.lookAtItemN(i).getName() + "\n";
		}
	
		return temp;
	}
	/**
	 * Closes the account of the current customer and removes all movies in atHome queue
	 */
	public void closeAccount() {
		//System.out.println(atHomeQueue.lookAtItemN(0).getName() + 'X');
		//System.out.println(atHomeQueue.lookAtItemN(1).getName() + "X");
		int homeSize = atHomeQueue.size();
		for(int i = 0; i < homeSize; i++){
			atHomeQueue.lookAtItemN(0).backToInventory();
			atHomeQueue.remove(0);
		}

		
	}
	
	/**
	 * Returns a movie the customer currently has at home
	 * @param index Index of the movie to be returned
	 */
	public void returnDVD(int index) {
		if(index < 0 || index >= atHomeQueue.size()){
			throw new IllegalArgumentException();
		}
		
		atHomeQueue.lookAtItemN(index).backToInventory();
		atHomeQueue.remove(index);
		nowAtHome--;
		
		
		int i = 0;
		while(nowAtHome < maxAtHome && !reserveQueue.isEmpty() && i < reserveQueue.size()){
			
				
			if(reserveQueue.lookAtItemN(i).isAvailable()){
				reserveQueue.lookAtItemN(i).removeOneCopyFromInventory();
				atHomeQueue.addToRear(reserveQueue.remove(i));
				i--;
				nowAtHome++;
			}
			i++;
		}
		
	}
	
	/**
	 * Move the selected movie up one in the reserve queue
	 * @param index Index in the reserve queue of the movie to be moved
	 */
	public void moveAheadOneInReserves(int index) {
		if(index < 0 || index >= reserveQueue.size()){
			throw new IllegalArgumentException();
		}
		
		reserveQueue.moveAheadOne(index);
		
	}
	
	/**
	 * Unreserves a certain movie 
	 * @param index Index of the movie to be removed from the reserve queue
	 */
	public void unReserve(int index) {
		if(index < 0 || index >= reserveQueue.size()){
			throw new IllegalArgumentException("No movie selected.");
		}
		
		reserveQueue.remove(index);
		
		
	}
	
	/**
	 * Reserves the selected movie
	 * @param m Movie to be added to the reserve or atHome queue
	 */
	public void reserve(Movie m) {
		if(m == null){
			throw new IllegalArgumentException("Movie not specified.");
		}
		
		if(nowAtHome < maxAtHome){
			if(m.isAvailable()){
			m.removeOneCopyFromInventory();
			atHomeQueue.addToRear(m);
			nowAtHome++;
			
			} else {
				reserveQueue.addToRear(m);
			}
		} else {
		reserveQueue.addToRear(m);
		}
	}
	
	//private String traverseQueue(MultiPurposeList<Movie> list) {
		
		//return null;
	//}
	
	///private void checkOut() {
		
	//}
	 
	//private Movie removeFirstAvailable() {
		
	//	return null;
	//}
}
