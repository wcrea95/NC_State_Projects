/**
 * 
 */
package edu.ncsu.csc216.flix_2.list_util;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

/**
 * Tests the MultiPurposeList object
 * @author Will
 *
 */
public class MultiPurposeListTest {

	/**
	 * The list used in a few methods.
	 */
	MultiPurposeList<String> list;
	
	/**
	 * This method sets up some of the necessary fields that some of the methods will use. This method is called
	 * before all of the other methods. 
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		list = new MultiPurposeList<String>();
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.list_util.MultiPurposeList#MultiPurposeList()}.
	 */
	@Test
	public void testMultiPurposeList() {
		MultiPurposeList<String> sList = new MultiPurposeList<String>();
		
		assertFalse(sList.hasNext());
		assertTrue(sList.isEmpty());
		assertNull(sList.remove(0));
		assertNull(sList.lookAtItemN(0));
		assertEquals(0, sList.size());
		assertNull(sList.next());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.list_util.MultiPurposeList#resetIterator()}.
	 */
	@Test
	public void testResetIterator() {
		MultiPurposeList<String> sList = new MultiPurposeList<String>();
		
		assertNull(sList.next());
		assertFalse(sList.hasNext());
		
		sList.addItem(0, "s0");
		sList.addItem(1, "s1");
		sList.addItem(2, "s2");
		
		assertNull(sList.next());
		assertFalse(sList.hasNext());
		
		sList.resetIterator();
		
		assertEquals("s0", sList.next());
		assertEquals("s1", sList.next());
		assertEquals("s2", sList.next());
		
		assertNull(sList.next());
		assertNull(sList.next());
		
		assertEquals("s0", sList.remove(0));
		assertNull(sList.next());
		
		sList.resetIterator();
		
		assertEquals("s1", sList.next());
		assertEquals("s2", sList.next());
		
		assertNull(sList.next());
		assertNull(sList.next());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.list_util.MultiPurposeList#hasNext()}.
	 */
	@Test
	public void testHasNext() {
		MultiPurposeList<String> sList = new MultiPurposeList<String>();
		
		assertFalse(sList.hasNext());
		
		sList.resetIterator();
		assertFalse(sList.hasNext());
		
		sList.addItem(0, "s");
		assertFalse(sList.hasNext());
		
		sList.resetIterator();
		assertTrue(sList.hasNext());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.list_util.MultiPurposeList#next()}.
	 */
	@Test
	public void testNext() {
		MultiPurposeList<String> sList = new MultiPurposeList<String>();
		
		sList.addItem(0, "s0");
		sList.addItem(1, "s1");
		sList.addItem(2, "s2");
		sList.resetIterator();
		
		assertEquals("s0", sList.next());
		assertEquals("s1", sList.next());
		assertEquals("s2", sList.next());
		
		assertNull(sList.next());
		assertNull(sList.next());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.list_util.MultiPurposeList#addItem(int, java.lang.Object)}.
	 */
	@Test
	public void testAddItem() {
		list.addItem(0, "s0");
		assertEquals("s0", list.lookAtItemN(0));
		
		list.addItem(1, "s1");
		assertEquals("s0", list.lookAtItemN(0));
		assertEquals("s1", list.lookAtItemN(1));
		
		list.addItem(0, "s2");
		assertEquals("s2", list.lookAtItemN(0));
		assertEquals("s0", list.lookAtItemN(1));
		assertEquals("s1", list.lookAtItemN(2));

		list.addItem(1, "s3");
		assertEquals("s2", list.lookAtItemN(0));
		assertEquals("s3", list.lookAtItemN(1));
		assertEquals("s0", list.lookAtItemN(2));
		assertEquals("s1", list.lookAtItemN(3));
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.list_util.MultiPurposeList#isEmpty()}.
	 */
	@Test
	public void testIsEmpty() {
		MultiPurposeList<String> sList = new MultiPurposeList<String>();
		
		assertTrue(sList.isEmpty());
		
		sList.addItem(0, "s0");
		assertFalse(sList.isEmpty());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.list_util.MultiPurposeList#lookAtItemN(int)}.
	 */
	@Test
	public void testLookAtItemN() {
		MultiPurposeList<String> sList = new MultiPurposeList<String>();
		
		assertNull(sList.lookAtItemN(-1));
		assertNull(sList.lookAtItemN(1));
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.list_util.MultiPurposeList#addToRear(java.lang.Object)}.
	 */
	@Test
	public void testAddToRear() {
		MultiPurposeList<Integer> iList = new MultiPurposeList<Integer>();
		
		iList.addToRear(0);
		assertEquals(0, iList.lookAtItemN(0).intValue());
		
		iList.addToRear(1);
		assertEquals(1, iList.lookAtItemN(1).intValue());
		
		iList.addToRear(2);
		assertEquals(2, iList.lookAtItemN(2).intValue());
		
		iList.addToRear(5);
		iList.addToRear(5);
		iList.addToRear(5);
		iList.addToRear(5);
		iList.addToRear(10);
		
		assertEquals(10, iList.lookAtItemN(7).intValue());
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.list_util.MultiPurposeList#remove(int)}.
	 */
	@Test
	public void testRemove() {
		MultiPurposeList<String> sList = new MultiPurposeList<String>();
		
		sList.addItem(0, "s0");
		sList.addItem(1, "s1");
		sList.addItem(2, "s2");
		sList.addItem(3, "s3");
		sList.addItem(4, "s4");
		
		assertEquals("s0", sList.lookAtItemN(0));
		assertEquals("s1", sList.lookAtItemN(1));
		assertEquals("s2", sList.lookAtItemN(2));
		assertEquals("s3", sList.lookAtItemN(3));
		assertEquals("s4", sList.lookAtItemN(4));
		
		assertEquals("s4", sList.remove(4));
		assertEquals("s0", sList.lookAtItemN(0));
		assertEquals("s1", sList.lookAtItemN(1));
		assertEquals("s2", sList.lookAtItemN(2));
		assertEquals("s3", sList.lookAtItemN(3));
		assertNull(sList.lookAtItemN(4));
		
		assertEquals("s0", sList.remove(0));
		assertEquals("s1", sList.lookAtItemN(0));
		assertEquals("s2", sList.lookAtItemN(1));
		assertEquals("s3", sList.lookAtItemN(2));
		assertNull(sList.lookAtItemN(3));
		
		assertEquals("s2", sList.remove(1));
		assertEquals("s1", sList.lookAtItemN(0));
		assertEquals("s3", sList.lookAtItemN(1));
		assertNull(sList.lookAtItemN(2));
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.list_util.MultiPurposeList#moveAheadOne(int)}.
	 */
	@Test
	public void testMoveAheadOne() {
		MultiPurposeList<String> sList = new MultiPurposeList<String>();
		
		sList.addItem(0, "s0");
		sList.addItem(1, "s1");
		sList.addItem(2, "s2");
		sList.addItem(3, "s3");
		sList.addItem(4, "s4");
		
		assertEquals("s0", sList.lookAtItemN(0));
		assertEquals("s1", sList.lookAtItemN(1));
		assertEquals("s2", sList.lookAtItemN(2));
		assertEquals("s3", sList.lookAtItemN(3));
		assertEquals("s4", sList.lookAtItemN(4));
		
		sList.moveAheadOne(4);
		assertEquals("s0", sList.lookAtItemN(0));
		assertEquals("s1", sList.lookAtItemN(1));
		assertEquals("s2", sList.lookAtItemN(2));
		assertEquals("s4", sList.lookAtItemN(3));
		assertEquals("s3", sList.lookAtItemN(4));
		
		sList.moveAheadOne(3);
		assertEquals("s0", sList.lookAtItemN(0));
		assertEquals("s1", sList.lookAtItemN(1));
		assertEquals("s4", sList.lookAtItemN(2));
		assertEquals("s2", sList.lookAtItemN(3));
		assertEquals("s3", sList.lookAtItemN(4));
		
		sList.moveAheadOne(2);
		assertEquals("s0", sList.lookAtItemN(0));
		assertEquals("s4", sList.lookAtItemN(1));
		assertEquals("s1", sList.lookAtItemN(2));
		assertEquals("s2", sList.lookAtItemN(3));
		assertEquals("s3", sList.lookAtItemN(4));
		
		sList.moveAheadOne(1);
		assertEquals("s4", sList.lookAtItemN(0));
		assertEquals("s0", sList.lookAtItemN(1));
		assertEquals("s1", sList.lookAtItemN(2));
		assertEquals("s2", sList.lookAtItemN(3));
		assertEquals("s3", sList.lookAtItemN(4));
		
		sList.moveAheadOne(0);
		assertEquals("s4", sList.lookAtItemN(0));
		assertEquals("s0", sList.lookAtItemN(1));
		assertEquals("s1", sList.lookAtItemN(2));
		assertEquals("s2", sList.lookAtItemN(3));
		assertEquals("s3", sList.lookAtItemN(4));
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.flix_2.list_util.MultiPurposeList#size()}.
	 */
	@Test
	public void testSize() {
		MultiPurposeList<String> sList = new MultiPurposeList<String>();
		
		assertEquals(0, sList.size());
		
		sList.addItem(0, "s0");
		assertEquals(1, sList.size());
		
		sList.addItem(1, "s1");
		sList.addItem(2, "s2");
		sList.addItem(3, "s3");
		sList.addItem(4, "s4");
		
		assertEquals(5, sList.size());
	}

}
