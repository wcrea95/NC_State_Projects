package edu.ncsu.csc216.flix_2.customer;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

import edu.ncsu.csc216.flix_2.inventory.Movie;

/**
 * This class is designed to test the Customer class. 
 * @author Will
 *
 */
public class CustomerTest {

	private Customer c1;
	
	/**
	 * This method is called before all of the other methods and is currently unused. 
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		c1 = new Customer("wcrea", "pw", 5); 
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.Customer#Customer(java.lang.String, java.lang.String, int)}.
	 */
	@Test
	public void testCustomer() {
		Customer c = new Customer("sc", "mat", 3);
		
		assertEquals("sc", c.getId());
		
		c.reserve(new Movie("1 Frozen"));
		c.reserve(new Movie("2 Amazing"));
		c.reserve(new Movie("3 Lame"));
		
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());

		c.reserve(new Movie("0 IDK"));
		c.reserve(new Movie("0 WOW"));
		c.reserve(new Movie("0 BRUH"));
		c.reserve(new Movie("3 CHILL"));
		
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());

		//c.closeAccount();
		//System.out.println("X");
		//System.out.println(c.traverseAtHomeQueue());
		
		c.returnDVD(2);
		c.returnDVD(0);
		assertEquals("Amazing\nCHILL\n", c.traverseAtHomeQueue());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.Customer#verifyPassword(java.lang.String)}.
	 */
	@Test
	public void testVerifyPassword() {
		assertTrue(c1.verifyPassword("pw"));
		assertFalse(c1.verifyPassword("incorrect"));
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.Customer#compareToByName(edu.ncsu.csc216.flix_2.customer.Customer)}.
	 */
	@Test
	public void testCompareToByName() {
		Customer compare = new Customer("wcrea", "pw2", 3);
		
		assertEquals(c1.compareToByName(compare), compare.compareToByName(c1));
		assertEquals(0, c1.compareToByName(compare));
		
		Customer andrew = new Customer("Andrew", "pw", 5);
		
		assertEquals(22, c1.compareToByName(andrew));
		assertEquals(-22, andrew.compareToByName(c1));
		
		compare.closeAccount();
		andrew.closeAccount();
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.Customer#traverseReserveQueue()}.
	 */
	@Test
	public void testTraverseReserveQueue() {
		Customer c = new Customer("sc", "mat", 3);
		
		c.reserve(new Movie("1 Frozen"));
		c.reserve(new Movie("2 Amazing"));
		c.reserve(new Movie("3 Lame"));
		
		assertEquals("", c.traverseReserveQueue());

		c.reserve(new Movie("1 IDK"));
		c.reserve(new Movie("1 WOW"));
		c.reserve(new Movie("0 BRUH"));
		c.reserve(new Movie("3 CHILL"));
		
		assertEquals("IDK\nWOW\nBRUH\nCHILL\n", c.traverseReserveQueue());
		
		c.returnDVD(0);
		
		assertEquals("WOW\nBRUH\nCHILL\n", c.traverseReserveQueue());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.Customer#traverseAtHomeQueue()}.
	 */
	@Test
	public void testTraverseAtHomeQueue() {
		Customer c = new Customer("sc", "mat", 3);
		
		c.reserve(new Movie("1 Frozen"));
		c.reserve(new Movie("2 Amazing"));
		c.reserve(new Movie("3 Lame"));
		
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());

		c.reserve(new Movie("0 IDK"));
		c.reserve(new Movie("0 WOW"));
		c.reserve(new Movie("0 BRUH"));
		c.reserve(new Movie("3 CHILL"));
		
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.Customer#returnDVD(int)}.
	 */
	@Test
	public void testReturnDVD() {
		Customer c = new Customer("sc", "mat", 3);
		
		c.reserve(new Movie("1 Frozen"));
		c.reserve(new Movie("2 Amazing"));
		c.reserve(new Movie("3 Lame"));
		
		assertEquals("", c.traverseReserveQueue());
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());

		c.reserve(new Movie("1 IDK"));
		c.reserve(new Movie("1 WOW"));
		c.reserve(new Movie("0 BRUH"));
		c.reserve(new Movie("3 CHILL"));
		
		assertEquals("IDK\nWOW\nBRUH\nCHILL\n", c.traverseReserveQueue());
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());
		
		c.returnDVD(0);
		
		assertEquals("WOW\nBRUH\nCHILL\n", c.traverseReserveQueue());
		assertEquals("Amazing\nLame\nIDK\n", c.traverseAtHomeQueue());
		
		c.returnDVD(0);
		c.returnDVD(0);
		
		assertEquals("BRUH\n", c.traverseReserveQueue());
		assertEquals("IDK\nWOW\nCHILL\n", c.traverseAtHomeQueue());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.Customer#moveAheadOneInReserves(int)}.
	 */
	@Test
	public void testMoveAheadOneInReserves() {
		Customer c = new Customer("sc", "mat", 3);
		
		c.reserve(new Movie("1 Frozen"));
		c.reserve(new Movie("2 Amazing"));
		c.reserve(new Movie("3 Lame"));
		
		assertEquals("", c.traverseReserveQueue());
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());

		c.reserve(new Movie("1 IDK"));
		c.reserve(new Movie("1 WOW"));
		c.reserve(new Movie("0 BRUH"));
		c.reserve(new Movie("3 CHILL"));
		
		assertEquals("IDK\nWOW\nBRUH\nCHILL\n", c.traverseReserveQueue());
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());
		
		c.moveAheadOneInReserves(3);
		c.moveAheadOneInReserves(2);
		c.moveAheadOneInReserves(1);
		
		assertEquals("CHILL\nIDK\nWOW\nBRUH\n", c.traverseReserveQueue());
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.Customer#unReserve(int)}.
	 */
	@Test
	public void testUnReserve() {
		Customer c = new Customer("sc", "mat", 3);
		
		c.reserve(new Movie("1 Frozen"));
		c.reserve(new Movie("2 Amazing"));
		c.reserve(new Movie("3 Lame"));
		
		assertEquals("", c.traverseReserveQueue());
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());

		c.reserve(new Movie("1 IDK"));
		c.reserve(new Movie("1 WOW"));
		c.reserve(new Movie("0 BRUH"));
		c.reserve(new Movie("3 CHILL"));
		
		assertEquals("IDK\nWOW\nBRUH\nCHILL\n", c.traverseReserveQueue());
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.customer.Customer#reserve(edu.ncsu.csc216.flix_2.inventory.Movie)}.
	 */
	@Test
	public void testReserve() {
		Customer c = new Customer("sc", "mat", 3);
		
		c.reserve(new Movie("1 Frozen"));
		c.reserve(new Movie("2 Amazing"));
		c.reserve(new Movie("3 Lame"));
		
		assertEquals("", c.traverseReserveQueue());
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());

		c.reserve(new Movie("1 IDK"));
		c.reserve(new Movie("1 WOW"));
		c.reserve(new Movie("0 BRUH"));
		c.reserve(new Movie("3 CHILL"));
		
		assertEquals("IDK\nWOW\nBRUH\nCHILL\n", c.traverseReserveQueue());
		assertEquals("Frozen\nAmazing\nLame\n", c.traverseAtHomeQueue());
		
		c.unReserve(2);
		assertEquals("IDK\nWOW\nCHILL\n", c.traverseReserveQueue());
		
		c.unReserve(0);
		assertEquals("WOW\nCHILL\n", c.traverseReserveQueue());
		
		c.unReserve(1);
		assertEquals("WOW\n", c.traverseReserveQueue());
	}

}
