/**
 * 
 */
package edu.ncsu.csc216.flix_2.customer;

import edu.ncsu.csc216.flix_2.rental_system.RentalManager;

/**
 * Creates and modifies a MovieCustomerAccountSystem
 * @author Will
 *
 */
public class MovieCustomerAccountSystem implements CustomerAccountManager {
	
	/**
	 * Return true if an administrator is logged in
	 */
	private boolean adminLoggedIn;
	
	/**
	 * Return true if a customer is logged in
	 */
	private boolean customerLoggedIn;
	
	/**
	 * Database of customers
	 */
	private CustomerDB customerList;
	
	/**
	 * Manages the rental system
	 */
	private RentalManager inventorySystem;
	
	/**
	 * String representing an administrators username and password
	 */
	private static final String ADMIN = "admin";
	
	/**
	 * Constructs a MovieCustomerAccountSystem
	 * @param manager RentalManager object to be used 
	 */
	public MovieCustomerAccountSystem(RentalManager manager) {
		customerList = new CustomerDB();
		inventorySystem = manager;
	}

	/**
	 * Logs in an administrator or customer based on the entered username and password
	 * @param username Username of the account
	 * @param password Password of the account
	 */
	@Override
	public void login(String username, String password) {
		if(adminLoggedIn || customerLoggedIn){
			throw new IllegalStateException("Current customer or admin must first log out.");
		}
		
		if(username.trim().equalsIgnoreCase(ADMIN) && password.trim().equalsIgnoreCase(ADMIN)){
			adminLoggedIn = true;
			return;
		}
		
		try {
				inventorySystem.setCustomer(customerList.verifyCustomer(username, password));
				customerLoggedIn = true;
		} catch (IllegalArgumentException e){
			throw new IllegalArgumentException("The account doesn't exist.");
			
		}
	
		
	}

	/**
	 * Makes sure no account is currently logged in
	 */
	@Override
	public void logout() {
		customerLoggedIn = false;
		adminLoggedIn = false;
	}

	/**
	 * Whether or not an administrator is logged in
	 * @return True if an administrator is logged in
	 */
	@Override
	public boolean isAdminLoggedIn() {
		return adminLoggedIn;
	}

	/**
	 * Whether or not a customer is logged in
	 * @return True if a customer is logged in
	 */
	@Override
	public boolean isCustomerLoggedIn() {
		return customerLoggedIn;
	}

	/**
	 * Adds a new customer to the customer database
	 * @param id Id of the customer to be added
	 * @param password Password of the customer to be added
	 * @param num Maximum number of movies the customer is allowed at home
	 */
	@Override
	public void addNewCustomer(String id, String password, int num) {
		if(!adminLoggedIn){
			throw new IllegalStateException("Access denied.");
		}
		
		try {
		customerList.addNewCustomer(id, password, num);
		} catch (IllegalStateException e){
			throw new IllegalStateException("Access denied.");
		} catch (IllegalArgumentException e){
			throw new IllegalArgumentException();
		}
		
		
	}

	/**
	 * Removes the specified account from the database
	 */
	@Override
	public void cancelAccount(String id) {
		if(!adminLoggedIn){
			throw new IllegalStateException("Access denied.");
		}
		
		try{
		customerList.cancelAccount(id);
		} catch (IllegalArgumentException e){
			throw new IllegalArgumentException();
		}
		
		
	}

	/**
	 * Lists the accounts in the database alphabetically and separated by newlines
	 * 
	 */
	@Override
	public String listAccounts() {
		return customerList.listAccounts();
	}

}
