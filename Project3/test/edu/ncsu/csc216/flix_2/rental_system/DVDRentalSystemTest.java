/**
 * 
 */
package edu.ncsu.csc216.flix_2.rental_system;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

import edu.ncsu.csc216.flix_2.customer.Customer;

/**
 * This class is used to test the DVDRentalSystemClass.
 * @author Will
 *
 */
public class DVDRentalSystemTest {

	/**
	 * This method is called before all of the other methods and is currently unused. 
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		//This method is unused. 
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.rental_system.DVDRentalSystem#DVDRentalSystem(java.lang.String)}.
	 */
	@Test
	public void testDVDRentalSystem() {
		DVDRentalSystem test = new DVDRentalSystem("test-files/movies.txt");
		
		try {
			test.addToCustomerQueue(0);
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		try {
			test.removeSelectedFromReserves(0);
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		try {
			test.reserveMoveAheadOne(0);
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		try {
			test.returnItemToInventory(0);
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		try {
			test.traverseAtHomeQueue();
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		try {
			test.traverseReserveQueue();
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.rental_system.DVDRentalSystem#showInventory()}.
	 */
	@Test
	public void testShowInventory() {
		DVDRentalSystem test = new DVDRentalSystem("test-files/moviesmall.txt");
		
		assertFalse(test.showInventory().isEmpty());
		String correct = "Beasts of the Southern Wild\nMurder 3\nNo\nNoah (currently unavailable)\n"
				+ "Promised Land\nSafe Haven\nSide Effects\n";
		
		assertEquals(correct, test.showInventory());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.rental_system.DVDRentalSystem#setCustomer(edu.ncsu.csc216.flix_2.customer.Customer)}.
	 */
	@Test
	public void testSetCustomer() {
		DVDRentalSystem test = new DVDRentalSystem("test-files/movies.txt");
		Customer customer0 = new Customer("wcrea", "pw", 5);
		
		try {
			test.addToCustomerQueue(0);
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		try {
			test.removeSelectedFromReserves(0);
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		try {
			test.reserveMoveAheadOne(0);
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		try {
			test.returnItemToInventory(0);
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		try {
			test.traverseAtHomeQueue();
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		try {
			test.traverseReserveQueue();
			fail("Expected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
		
		test.setCustomer(customer0);
		
		try {
			test.addToCustomerQueue(0);
			assertFalse(test.traverseAtHomeQueue().isEmpty());
		} catch (Exception e) {
			fail("Unexpected exception.");
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.rental_system.DVDRentalSystem#addToCustomerQueue(int)}.
	 */
	@Test
	public void testAddToCustomerQueue() {
		DVDRentalSystem test = new DVDRentalSystem("test-files/movies.txt");
		Customer customer0 = new Customer("wcrea", "pw", 2);
		test.setCustomer(customer0);
		
		assertTrue(test.traverseAtHomeQueue().isEmpty());
		assertTrue(test.traverseReserveQueue().isEmpty());
		
		test.addToCustomerQueue(0);
		assertFalse(test.traverseAtHomeQueue().isEmpty());
		assertTrue(test.traverseReserveQueue().isEmpty());
		
		test.addToCustomerQueue(1);
		test.addToCustomerQueue(2);
		assertFalse(test.traverseAtHomeQueue().isEmpty());
		assertFalse(test.traverseReserveQueue().isEmpty());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.rental_system.DVDRentalSystem#reserveMoveAheadOne(int)}.
	 */
	@Test
	public void testReserveMoveAheadOne() {
		DVDRentalSystem test = new DVDRentalSystem("test-files/movies.txt");
		Customer customer0 = new Customer("wcrea", "pw", 2);
		test.setCustomer(customer0);
		
		assertTrue(test.traverseAtHomeQueue().isEmpty());
		assertTrue(test.traverseReserveQueue().isEmpty());
		
		test.addToCustomerQueue(0);
		assertFalse(test.traverseAtHomeQueue().isEmpty());
		assertTrue(test.traverseReserveQueue().isEmpty());
		
		test.addToCustomerQueue(1);
		test.addToCustomerQueue(2);
		test.addToCustomerQueue(3);
		test.addToCustomerQueue(4);
		assertFalse(test.traverseAtHomeQueue().isEmpty());
		assertFalse(test.traverseReserveQueue().isEmpty());
		assertEquals("About Schmidt\nAloha\nThe Amazing Spider-man 2\n", test.traverseReserveQueue());
		
		test.reserveMoveAheadOne(2);
		test.reserveMoveAheadOne(1);
		assertEquals("The Amazing Spider-man 2\nAbout Schmidt\nAloha\n", test.traverseReserveQueue());
		
		try {
			test.reserveMoveAheadOne(-1);
			fail("Excpeted an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
		
		try {
			test.reserveMoveAheadOne(5);
			fail("Excpected an exception.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalArgumentException);
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.rental_system.DVDRentalSystem#removeSelectedFromReserves(int)}.
	 */
	@Test
	public void testRemoveSelectedFromReserves() {
		DVDRentalSystem test = new DVDRentalSystem("test-files/movies.txt");
		Customer customer0 = new Customer("wcrea", "pw", 2);
		test.setCustomer(customer0);
		
		assertTrue(test.traverseReserveQueue().isEmpty());
		
		test.addToCustomerQueue(0);
		assertTrue(test.traverseReserveQueue().isEmpty());
		
		test.addToCustomerQueue(1);
		test.addToCustomerQueue(2);
		test.addToCustomerQueue(3);
		test.addToCustomerQueue(4);
		assertFalse(test.traverseAtHomeQueue().isEmpty());
		assertFalse(test.traverseReserveQueue().isEmpty());
		assertEquals("About Schmidt\nAloha\nThe Amazing Spider-man 2\n", test.traverseReserveQueue());
		
		test.removeSelectedFromReserves(1);
		assertEquals("About Schmidt\nThe Amazing Spider-man 2\n", test.traverseReserveQueue());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.rental_system.DVDRentalSystem#traverseReserveQueue()}.
	 */
	@Test
	public void testTraverseReserveQueue() {
		DVDRentalSystem test = new DVDRentalSystem("test-files/movies.txt");
		Customer customer0 = new Customer("wcrea", "pw", 2);
		test.setCustomer(customer0);
		
		assertTrue(test.traverseReserveQueue().isEmpty());
		
		test.addToCustomerQueue(0);
		assertTrue(test.traverseReserveQueue().isEmpty());
		
		test.addToCustomerQueue(1);
		test.addToCustomerQueue(2);
		test.addToCustomerQueue(3);
		test.addToCustomerQueue(4);
		assertFalse(test.traverseAtHomeQueue().isEmpty());
		assertFalse(test.traverseReserveQueue().isEmpty());
		assertEquals("About Schmidt\nAloha\nThe Amazing Spider-man 2\n", test.traverseReserveQueue());
		
		test.returnItemToInventory(0);
		assertEquals("Aloha\nThe Amazing Spider-man 2\n", test.traverseReserveQueue());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.rental_system.DVDRentalSystem#traverseAtHomeQueue()}.
	 */
	@Test
	public void testTraverseAtHomeQueue() {
		DVDRentalSystem test = new DVDRentalSystem("test-files/movies.txt");
		Customer customer0 = new Customer("wcrea", "pw", 2);
		test.setCustomer(customer0);
		
		assertTrue(test.traverseAtHomeQueue().isEmpty());
		
		test.addToCustomerQueue(0);
		assertFalse(test.traverseAtHomeQueue().isEmpty());
		
		test.addToCustomerQueue(1);
		assertFalse(test.traverseAtHomeQueue().isEmpty());
		assertEquals("12 Years a Slave\n300: Rise of an Empire\n", test.traverseAtHomeQueue());
		
		test.returnItemToInventory(0);
		assertEquals("300: Rise of an Empire\n", test.traverseAtHomeQueue());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.rental_system.DVDRentalSystem#returnItemToInventory(int)}.
	 */
	@Test
	public void testReturnItemToInventory() {
		DVDRentalSystem test = new DVDRentalSystem("test-files/movies.txt");
		Customer customer0 = new Customer("wcrea", "pw", 2);
		test.setCustomer(customer0);
		
		assertTrue(test.traverseReserveQueue().isEmpty());
		
		test.addToCustomerQueue(0);
		assertTrue(test.traverseReserveQueue().isEmpty());
		
		test.addToCustomerQueue(1);
		test.addToCustomerQueue(2);
		test.addToCustomerQueue(3);
		test.addToCustomerQueue(4);
		assertFalse(test.traverseAtHomeQueue().isEmpty());
		assertFalse(test.traverseReserveQueue().isEmpty());
		assertEquals("About Schmidt\nAloha\nThe Amazing Spider-man 2\n", test.traverseReserveQueue());
		
		test.returnItemToInventory(0);
		assertEquals("300: Rise of an Empire\nAbout Schmidt\n", test.traverseAtHomeQueue());
		assertEquals("Aloha\nThe Amazing Spider-man 2\n", test.traverseReserveQueue());
	}

}
