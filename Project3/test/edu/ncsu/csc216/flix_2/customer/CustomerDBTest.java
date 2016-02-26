/**
 * 
 */
package edu.ncsu.csc216.flix_2.customer;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

/**
 * This class is designed to test the CustomerDB class.
 * @author Will
 *
 */
public class CustomerDBTest {

	/**
	 * This method is called before all of the other methods and is currently unused. 
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		//Unused method.
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.CustomerDB#CustomerDB()}.
	 */
	@Test
	public void testCustomerDB() {
		CustomerDB test = new CustomerDB();
		
		try {
			test.verifyCustomer("username", "password");
			fail("CustomerDB did not throw an IllegalArgumentException");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
		
		assertEquals("", test.listAccounts());
		
		test.addNewCustomer("b", "naruto91", 1);
		test.addNewCustomer("a", "naruto91", 1);
		test.addNewCustomer("c", "naruto91", 1);
		//System.out.println(test.listAccounts());
		
		test.addNewCustomer("g", "naruto91", 1);
		test.cancelAccount("g");
		System.out.println(test.listAccounts());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.CustomerDB#verifyCustomer(java.lang.String, java.lang.String)}.
	 */
	@Test
	public void testVerifyCustomer() {
		CustomerDB test = new CustomerDB();
		
		try {
			test.verifyCustomer(null, "password");
			fail("CustomerDB did not throw an IllegalArgumentException");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
		
		try {
			test.verifyCustomer("username", null);
			fail("CustomerDB did not throw an IllegalArgumentException");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
		
		try {
			test.verifyCustomer("username", "password");
			fail("CustomerDB did not throw an IllegalArgumentException");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
		
		test.addNewCustomer("b", "naruto91", 1);
		
		try {
			test.verifyCustomer(null, "password");
			fail("CustomerDB did not throw an IllegalArgumentException");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
		
		try {
			test.verifyCustomer("username", null);
			fail("CustomerDB did not throw an IllegalArgumentException");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
		
		try {
			test.verifyCustomer("b", "naruto91");
		} catch (Exception e) {
			fail("verifyCustomer threw an unexpected exception.");
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.CustomerDB#listAccounts()}.
	 */
	@Test
	public void testListAccounts() {
		CustomerDB test = new CustomerDB();
		
		assertEquals("", test.listAccounts());
		
		test.addNewCustomer("b", "naruto91", 1);
		
		assertEquals("b\n", test.listAccounts());
		
		test.addNewCustomer("c", "naruto91", 1);
		test.addNewCustomer("d", "naruto91", 1);
		
		assertEquals("b\nc\nd\n", test.listAccounts());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.CustomerDB#addNewCustomer(java.lang.String, java.lang.String, int)}.
	 */
	@Test
	public void testAddNewCustomer() {
		CustomerDB test = new CustomerDB();
		
		assertEquals("", test.listAccounts());
		try {
			test.verifyCustomer("username", "password");
			fail("CustomerDB did not throw an IllegalArgumentException");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
		
		test.addNewCustomer("b", "naruto91", 1);
		
		assertEquals("b\n", test.listAccounts());
		
		test.addNewCustomer("c", "naruto91", 1);
		test.addNewCustomer("d", "naruto91", 1);
		
		assertEquals("b\nc\nd\n", test.listAccounts());
		try {
			test.verifyCustomer("b", "naruto91");
		} catch (Exception e) {
			fail("verifyCustomer threw an unexpected exception.");
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.CustomerDB#cancelAccount(java.lang.String)}.
	 */
	@Test
	public void testCancelAccount() {
		CustomerDB test = new CustomerDB();
		
		assertEquals("", test.listAccounts());
		
		test.addNewCustomer("b", "naruto91", 1);
		
		assertEquals("b\n", test.listAccounts());
		
		test.addNewCustomer("c", "naruto91", 1);
		test.addNewCustomer("d", "naruto91", 1);
		
		assertEquals("b\nc\nd\n", test.listAccounts());
		
		try {
			test.cancelAccount("g");
			fail("No exception was thrown.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
		
		test.cancelAccount("b");
		assertEquals("c\nd\n", test.listAccounts());
	}

}
