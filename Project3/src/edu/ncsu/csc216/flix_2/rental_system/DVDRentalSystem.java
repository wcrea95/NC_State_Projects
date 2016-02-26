/**
 * 
 */
package edu.ncsu.csc216.flix_2.rental_system;

import edu.ncsu.csc216.flix_2.customer.Customer;
import edu.ncsu.csc216.flix_2.inventory.MovieDB;

/**
 * Creates and modifies a DVDRentalSystem object
 * @author Will
 *
 */
public class DVDRentalSystem implements RentalManager {

	/**
	 * Database of movies
	 */
	private MovieDB rentalSystem;
	
	/**
	 * Customer currently logged in
	 */
	private Customer currentCustomer;
	
	/**
	 * Constructs a DVDRentalSystem object by initializing
	 * @param fileName Name of the file containing movie information 
	 */
	public DVDRentalSystem(String fileName) {
		rentalSystem  = new MovieDB(fileName);
		
		
	}
	
	/**
	 * Traverse all items in the inventory.
	 * @return the string representing the items in the inventory
	 */
	@Override
	public String showInventory() {
		// TODO Auto-generated method stub
		return rentalSystem.traverse();
	}

	/**
	 * Set the customer for the current context to a given value.
	 * @param c the new current customer
	 */
	@Override
	public void setCustomer(Customer c) {
		// TODO Auto-generated method stub
		
		this.currentCustomer = c;

	}

	/**
	 * Reserve the selected item for the reserve queue. 
	 * @param position position of the selected item in the inventory
	 * @throws IllegalStateException if no customer is logged in
	 * @throws IllegalArgumentException if position is out of bounds
	 */
	@Override
	public void addToCustomerQueue(int position) {
		// TODO Auto-generated method stub
		if(currentCustomer == null){
			throw new IllegalStateException("No customer is logged in.");
		}
		
		if(position < 0){
			throw new IllegalArgumentException();
		}
		//System.out.println(rentalSystem.findItemAt(position).getName() + "X");
		//if(rentalSystem.findItemAt(position).isAvailable()){
		currentCustomer.reserve(rentalSystem.findItemAt(position));
		//rentalSystem.findItemAt(position).removeOneCopyFromInventory();
		//} 

	}

	/**
	 * Move the item in the given position up 1 in the reserve queue. 
	 * @param position current position of item to move up one
	 * @throws IllegalStateException if no customer is logged in
	 */
	@Override
	public void reserveMoveAheadOne(int position) {
		// TODO Auto-generated method stub
		if(currentCustomer == null){
			throw new IllegalStateException("No customer is logged in.");
		}
		
		if(position < 0){
			throw new IllegalArgumentException();
		}
		
		try{
		currentCustomer.moveAheadOneInReserves(position);
		} catch (IllegalArgumentException e){
			throw new IllegalArgumentException();
		}

	}

	/**
	 * Remove the item in the given position from the reserve queue.
	 * @param position position of the item in the queue
	 * @throws IllegalStateException if no customer is logged in
	 * @throws IllegalArgumentException if position is out of bounds
	 */
	@Override
	public void removeSelectedFromReserves(int position) {
		// TODO Auto-generated method stub
		if(currentCustomer == null){
			throw new IllegalStateException("No customer is logged in.");
		}
		
		if(position < 0){
			throw new IllegalArgumentException();
		}
		
		try {
		currentCustomer.unReserve(position);
		} catch (IllegalArgumentException e){
			throw new IllegalArgumentException();
		}

	}

	/**
	 * Traverse all items in the reserve queue.
	 * @return string representation of items in the queue
	 * @throws IllegalStateException if no customer is logged in
	 */
	@Override
	public String traverseReserveQueue() {
		// TODO Auto-generated method stub
		if(currentCustomer == null){
			throw new IllegalStateException("No customer is logged in.");
		}
		
		return currentCustomer.traverseReserveQueue();
	}

	/**
	 * Traverse all items in the reserve queue.
	 * @return string representation of items at home
	 * @throws IllegalStateException if no customer is logged in
	 */
	@Override
	public String traverseAtHomeQueue() {
		// TODO Auto-generated method stub
		if(currentCustomer == null){
			throw new IllegalStateException("No customer is logged in.");
		}

		return currentCustomer.traverseAtHomeQueue();
	}

	/**
	 * Return the selected item to the inventory.
	 * @param position location in the list of items at home of the item to return
	 * @throws IllegalStateException if no customer is logged in
	 * @throws IllegalArgumentException if position is out of bounds
	 */
	@Override
	public void returnItemToInventory(int position) {
		// TODO Auto-generated method stub
		if(currentCustomer == null){
			throw new IllegalStateException("No customer is logged in.");
		}
		
		if(position < 0 ){
			throw new IllegalArgumentException();
		}
		
		try{
		currentCustomer.returnDVD(position);
		} catch (IllegalArgumentException e){
			throw new IllegalArgumentException();
		}
		

	}

}
