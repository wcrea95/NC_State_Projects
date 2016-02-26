/**
 * 
 */
package edu.ncsu.csc216.flix_2.customer;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

import edu.ncsu.csc216.flix_2.rental_system.DVDRentalSystem;
import edu.ncsu.csc216.flix_2.rental_system.RentalManager;

/**
 * This class is used to test the MovieCustomerAccountSystem class. 
 * @author Will
 *
 */
public class MovieCustomerAccountSystemTest {

	/**
	 * This method is called before all of the other methods and is unused.
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		//unused method.
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.MovieCustomerAccountSystem#MovieCustomerAccountSystem(edu.ncsu.csc216.flix_2.rental_system.RentalManager)}.
	 */
	@Test
	public void testMovieCustomerAccountSystem() {
		RentalManager test1 = new DVDRentalSystem("test-files/movies.txt");
		CustomerAccountManager test = new MovieCustomerAccountSystem(test1);
		
		test.login("admin ", "admin");
		assertTrue(test.isAdminLoggedIn());
		test.addNewCustomer("a", "WOW", 3);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.MovieCustomerAccountSystem#login(java.lang.String, java.lang.String)}.
	 */
	@Test
	public void testLogin() {
		RentalManager test1 = new DVDRentalSystem("test-files/movies.txt");
		CustomerAccountManager test = new MovieCustomerAccountSystem(test1);
		
		test.login("admin ", "admin");
		assertTrue(test.isAdminLoggedIn());
		test.addNewCustomer("a", "WOW", 3);
		
		try {
			test.login("a", "WOW");
			fail("login() did not throw an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		test.logout();
		
		try {
			test.login("b", "WOW");
			fail("An exception should have been thrown.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
		
		try {
			test.login("a", "WOW");
		} catch (Exception e) {
			fail("Login method threw an unexpected exception.");
		}
		
		try {
			test.login("a", "WOW");
			fail("login() did not throw an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.MovieCustomerAccountSystem#logout()}.
	 */
	@Test
	public void testLogout() {
		RentalManager test1 = new DVDRentalSystem("test-files/movies.txt");
		CustomerAccountManager test = new MovieCustomerAccountSystem(test1);
		
		assertFalse(test.isAdminLoggedIn());
		assertFalse(test.isCustomerLoggedIn());
		
		test.login("admin ", "admin");
		test.addNewCustomer("a", "WOW", 3);
		
		assertTrue(test.isAdminLoggedIn());
		assertFalse(test.isCustomerLoggedIn());
		
		try {
			test.login("a", "WOW");
			fail("login() did not throw an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		assertTrue(test.isAdminLoggedIn());
		assertFalse(test.isCustomerLoggedIn());
		
		test.logout();
		assertFalse(test.isAdminLoggedIn());
		assertFalse(test.isCustomerLoggedIn());
		
		try {
			test.login("b", "WOW");
			fail("An exception should have been thrown.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
		
		assertFalse(test.isAdminLoggedIn());
		assertFalse(test.isCustomerLoggedIn());
		
		try {
			test.login("a", "WOW");
		} catch (Exception e) {
			fail("Login method threw an unexpected exception.");
		}
		
		assertFalse(test.isAdminLoggedIn());
		assertTrue(test.isCustomerLoggedIn());
		
		try {
			test.login("a", "WOW");
			fail("login() did not throw an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		test.logout();
		assertFalse(test.isAdminLoggedIn());
		assertFalse(test.isCustomerLoggedIn());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.MovieCustomerAccountSystem#isAdminLoggedIn()}.
	 */
	@Test
	public void testIsAdminLoggedIn() {
		RentalManager test1 = new DVDRentalSystem("test-files/movies.txt");
		CustomerAccountManager test = new MovieCustomerAccountSystem(test1);
		
		assertFalse(test.isAdminLoggedIn());
		
		test.login("admin ", "admin");
		test.addNewCustomer("a", "WOW", 3);
		
		assertTrue(test.isAdminLoggedIn());
		
		test.logout();
		assertFalse(test.isAdminLoggedIn());
		
		test.login("a", "WOW");
		assertFalse(test.isAdminLoggedIn());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.MovieCustomerAccountSystem#isCustomerLoggedIn()}.
	 */
	@Test
	public void testIsCustomerLoggedIn() {
		RentalManager test1 = new DVDRentalSystem("test-files/movies.txt");
		CustomerAccountManager test = new MovieCustomerAccountSystem(test1);
		
		assertFalse(test.isCustomerLoggedIn());
		
		test.login("admin ", "admin");
		test.addNewCustomer("a", "WOW", 3);
		
		assertFalse(test.isCustomerLoggedIn());
		
		test.logout();
		assertFalse(test.isCustomerLoggedIn());
		
		test.login("a", "WOW");
		assertTrue(test.isCustomerLoggedIn());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.MovieCustomerAccountSystem#addNewCustomer(java.lang.String, java.lang.String, int)}.
	 */
	@Test
	public void testAddNewCustomer() {
		RentalManager test1 = new DVDRentalSystem("test-files/movies.txt");
		CustomerAccountManager test = new MovieCustomerAccountSystem(test1);
		
		test.login("admin ", "admin");
		test.addNewCustomer("a", "WOW", 3);
		
		test.logout();
		test.login("a", "WOW");
		
		assertTrue(test.isCustomerLoggedIn());
		
		try {
			test.addNewCustomer("wcrea", "pw", 3);
			fail("AddNewCustomer did not throw an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.MovieCustomerAccountSystem#cancelAccount(java.lang.String)}.
	 */
	@Test
	public void testCancelAccount() {
		RentalManager test1 = new DVDRentalSystem("test-files/movies.txt");
		CustomerAccountManager test = new MovieCustomerAccountSystem(test1);
		
		test.login("admin ", "admin");
		test.addNewCustomer("a", "WOW", 3);
		test.addNewCustomer("b", "WOW", 3);
		test.addNewCustomer("c", "WOW", 3);
		
		assertEquals("a\nb\nc\n", test.listAccounts());
		
		test.cancelAccount("b");
		assertEquals("a\nc\n", test.listAccounts());
		
		test.logout();
		test.login("a", "WOW");
		
		try {
			test.cancelAccount("c");
			fail("No exception was thrown when a customer is logged in.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.MovieCustomerAccountSystem#listAccounts()}.
	 */
	@Test
	public void testListAccounts() {
		RentalManager test1 = new DVDRentalSystem("test-files/movies.txt");
		CustomerAccountManager test = new MovieCustomerAccountSystem(test1);
		
		test.login("admin ", "admin");
		test.addNewCustomer("a", "WOW", 3);
		test.addNewCustomer("b", "WOW", 3);
		test.addNewCustomer("c", "WOW", 3);
		
		assertEquals("a\nb\nc\n", test.listAccounts());
		
		test.cancelAccount("b");
		assertEquals("a\nc\n", test.listAccounts());
	}

}
