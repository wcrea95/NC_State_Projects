/**
 * 
 */
package edu.ncsu.csc216.flix_2.inventory;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

/**
 * This class is designed to test the MovieDBTest class.
 * @author Will
 *
 */
public class MovieDBTest {

	/**
	 * This method is called before all of the other methods.
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		//This method is unused.
	}
	
	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.inventory.MovieDB#MovieDB(java.lang.String)}.
	 */
	@Test
	public void testMovieDB() {
		MovieDB test = new MovieDB("test-files/movies.txt");
		assertFalse(test.traverse().isEmpty());
		
		MovieDB failTest = null;
		try {
			failTest = new MovieDB("NoSuchFile.txt");
			fail("Constructor did not throw an exception.");
		} catch (Exception e) {
			assertNull(failTest);
			assertTrue(e instanceof IllegalArgumentException);
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.inventory.MovieDB#traverse()}.
	 */
	@Test
	public void testTraverse() {
		MovieDB test = new MovieDB("test-files/moviesmall.txt");
		
		assertFalse(test.traverse().isEmpty());
		String correct = "Beasts of the Southern Wild\nMurder 3\nNo\nNoah (currently unavailable)"
				+ "\nPromised Land\nSafe Haven\nSide Effects\n";
		
		assertEquals(correct, test.traverse());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.inventory.MovieDB#findItemAt(int)}.
	 */
	@Test
	public void testFindItemAt() {
		MovieDB test = new MovieDB("test-files/movies.txt");
		assertFalse(test.traverse().isEmpty());
		
		assertEquals("12 Years a Slave", test.findItemAt(0).getDisplayName());
		assertEquals(0, test.findItemAt(1).compareToByName(new Movie("4  300: Rise of an Empire")));
		
	}
}
