/**
 * 
 */
package edu.ncsu.csc216.flix_2.customer;

import java.util.Arrays;



/**
 * Creates and modifies a Customer database object
 * @author Will
 *
 */
public class CustomerDB {

	/**
	 * Maximum number of customers allowed in the database
	 */
	public static final int MAX_SIZE = 20;
	
	/**
	 * Current size of the database
	 */
	private int size;
	
	/**
	 * Array containing all the Customers in the database
	 */
	private Customer[] list;
	
	//private MultiPurposeList<Customer> customers;
	
	/**
	 * Constructs a CustomerDB by initializing the Customer list with length MAX_SIZE
	 * and setting size to 0
	 */
	public CustomerDB() {
		list = new Customer[MAX_SIZE];
		size = 0;
	}
	
	/**
	 * Verifies the passed in id and password are valid
	 * @param id Id of the Customer
	 * @param password Password of the Customer
	 * @return Customer object from the list if one exists
	 */
	public Customer verifyCustomer(String id, String password) {
		if(id == null || password == null){
			throw new IllegalArgumentException("The account doesn't exist.");
		}
		
		
		int index = findMatchingAccount(id);
		if(index == -1 || !list[index].verifyPassword(password)){
			throw new IllegalArgumentException("The account doesn't exist.");
		}
		
		return list[index];
	}
	
	/**
	 * Lists the customer accounts in alphabetical order
	 * @return String containing customer id's seperated by newlines
	 */
	public String listAccounts() {
		//Arrays.sort(list);
		String temp = "";
		String[] ids = new String[size];
		Customer[] tempList = list;
		Customer[] tempList2 = new Customer[size];
		
		for(int j = 0; j < size; j++){
			ids[j] = list[j].getId();
		}
		
		Arrays.sort(ids);
		System.out.println(Arrays.toString(ids));
		
		for(int k = 0; k < size; k++){
			int idIndex = findMatchingAccount(ids[k]);
			tempList2[k] = tempList[idIndex];
			
		}
		
		//list = tempList2;
		
		for(int i = 0; i < size; i++){
			temp += tempList2[i].getId() + "\n";
		}
		
		return temp;
	}
	
	/**
	 * Creates and adds a new customer to the list
	 * @param id Id of the new customer
	 * @param password Password of the new Customer
	 * @param max Maximum amount of movies the customer is allowed at home
	 */
	public void addNewCustomer(String id, String password, int max) {
		if(size == 20){
			throw new IllegalStateException();
		}
		
		if(id.contains(" ") || password.contains(" ")){
			throw new IllegalArgumentException();
		}
		
		if(id.equals("") || password.equals("") || !isNewCustomer(id)){
			throw new IllegalArgumentException();
		}
		Customer temp = new Customer(id, password, max);
		list[size] = temp;
		size++;
		
		
	}
	
	/**
	 * Removes the account matching the passed in Id from the database
	 * @param id Id of the customer account to be removed
	 */
	public void cancelAccount(String id) {
		if(isNewCustomer(id)){
			throw new IllegalArgumentException();
		}
		
		int index = findMatchingAccount(id);
		System.out.println(index);
		System.out.println(size);
		for(int i = index; i < size - 1; i++){
			list[i] = list[i + 1];
		}
		
		size--;
		
	}
	
	/**
	 * Determines if customer already exists in the database
	 * @param id Id of the customer
	 * @return True if customer does not already exist in the database
	 */
	private boolean isNewCustomer(String id) {
		
		return findMatchingAccount(id) == -1;
	}
	
	//private void insert(Customer c) {
		
	//}
	
	/**
	 * Looks to see if a matching account exists in the database
	 * @param id Customer Id to be searched for
	 * @return i Index of the matching customer
	 *         -1 If customer does not exist in the database
	 */
	private int findMatchingAccount(String id) {
		for(int i = 0; i < size; i++){
			if(list[i].getId().toLowerCase().equals(id.toLowerCase())){
				return i;
			}
			
		}
		return -1;
		
	}
}
