/**
 * 
 */
package edu.ncsu.csc216.flix_2.inventory;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

/**
 * This class is designed to test the Movie Class.
 * @author Will
 *
 */
public class MovieTest {

	/**
	 * This method is called before all of the other methods and is unused. 
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		//This method is unused. 
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.inventory.Movie#Movie(java.lang.String)}.
	 */
	@Test
	public void testMovie() {
		String test1 = "3 Frozen";
		String test2 = "1 American Sniper";
		Movie movieTest0 = new Movie(test1);
		Movie movieTest1 = new Movie(test2);
		
		assertEquals(0, movieTest0.compareToByName(movieTest0));
		assertTrue(movieTest0.compareToByName(movieTest1) > 0);
		assertEquals("Frozen", movieTest0.getDisplayName());
		assertTrue(movieTest0.isAvailable());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.inventory.Movie#getDisplayName()}.
	 */
	@Test
	public void testGetDisplayName() {
		Movie movieTest0 = new Movie("3 Frozen");
		Movie movieTest1 = new Movie("0 American Sniper");
		
		assertEquals("Frozen", movieTest0.getDisplayName());
		assertEquals("American Sniper (currently unavailable)", movieTest1.getDisplayName());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.inventory.Movie#compareToByName(edu.ncsu.csc216.flix_2.inventory.Movie)}.
	 */
	@Test
	public void testCompareToByName() {
		Movie movieTest0 = new Movie("3 Frozen");
		Movie movieTest1 = new Movie("0 American Sniper");
		
		assertEquals("Frozen", movieTest0.getDisplayName());
		assertEquals("American Sniper (currently unavailable)", movieTest1.getDisplayName());
		
		assertEquals(0, movieTest0.compareToByName(movieTest0));
		assertEquals(5, movieTest0.compareToByName(movieTest1));
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.inventory.Movie#isAvailable()}.
	 */
	@Test
	public void testIsAvailable() {
		Movie movieTest0 = new Movie("3 Frozen");
		Movie movieTest1 = new Movie("0 American Sniper");
		
		assertTrue(movieTest0.isAvailable());
		assertFalse(movieTest1.isAvailable());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.inventory.Movie#backToInventory()}.
	 */
	@Test
	public void testBackToInventory() {
		Movie movieTest1 = new Movie("0 American Sniper");
		assertFalse(movieTest1.isAvailable());
		
		movieTest1.backToInventory();
		assertTrue(movieTest1.isAvailable());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.inventory.Movie#removeOneCopyFromInventory()}.
	 */
	@Test
	public void testRemoveOneCopyFromInventory() {
		Movie movieTest0 = new Movie("3 Frozen");
		
		assertTrue(movieTest0.isAvailable());
		
		movieTest0.removeOneCopyFromInventory();
		assertTrue(movieTest0.isAvailable());
		
		movieTest0.removeOneCopyFromInventory();
		movieTest0.removeOneCopyFromInventory();
		assertFalse(movieTest0.isAvailable());
		
		try {
			movieTest0.removeOneCopyFromInventory();
			fail("An exception was not thrown.");
		} catch (Exception e) {
			assertTrue(e instanceof IllegalStateException);
		}
	}

}
