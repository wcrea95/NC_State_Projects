/**
 * 
 */
package edu.ncsu.csc216.flix_2.list_util;

/**
 * This class is used to keep track of objects of type T in a linked list way. This class
 * also makes use of an Iterator.
 * @author Will
 * @param <T> the type of objects in the list
 */
public class MultiPurposeList<T> {

	/**
	 * The front of the list.
	 */
	private Node head;
	
	/**
	 * The iterator for the list. This field is equal to the next object in the list.
	 */
	private Node iterator;
	
	/**
	 * The size of the list.
	 */
	private int size;
	
	/**
	 * This method constructs a new MultiPurposeList object. 
	 */
	public MultiPurposeList() {
		head = new Node(null, null);
		iterator = head;
		size = 0;
	}
	
	/**
	 * This method sets the Iterator to the first object in the list. 
	 */
	public void resetIterator() {
		iterator = head;
	}
	
	/**
	 * This method returns true if iterator is pointing to a Node with non-null data.
	 * @return returns false if iterator is equal to null or if iterator's data is null,
	 * otherwise return true
	 */
	public boolean hasNext() {
		if (iterator == null) {
			return false;
		}
		return iterator.data != null;
	}
	
	/**
	 * This method returns the data of iterator, then moves iterator to the next item in the list.
	 * @return returns the data of iterator
	 */
	public T next() {
		if (hasNext()) {
			T returnData = iterator.data;
			iterator = iterator.next;
			return returnData;
		}
		else {
			return null;
		}
	}
	
	/**
	 * This method adds an item to the list at the given index.
	 * @param index the index to add the item to
	 * @param data the item to be added to the list
	 */
	public void addItem(int index, T data) {
		if (index <= 0) {
			if (size == 0) {
				head = new Node(data, null);
			}
			else {
				Node temp = new Node(data, head);
				head = temp;
			}
		}
		else if (index >= size) {
			Node temp = new Node(data, null);
			Node current = head;
			
			while (current.next != null) {
				current = current.next;
			}
			
			current.next = temp;
		}
		else {
			Node current = head;
			for (int i = 0; i < index - 1; i++) {
				current = current.next;
			}
			
			Node temp = new Node(data, current.next);
			current.next = temp;
		}		
		size++;
	}
	
	/**
	 * This method returns true if there are no elements in the list.
	 * @return returns true if size is zero
	 */
	public boolean isEmpty() {
		return size == 0;
	}
	
	/**
	 * This method returns the data value of the element at the given index.
	 * @param index the index of the data to be returned
	 * @return returns the data at the given index
	 */
	public T lookAtItemN(int index) {
		if (index < 0 || index >= size) {
			return null;
		}
		
		if (index == 0) {
			return head.data;
		}
		else {
			Node current = head;
			for (int i = 0; i < index; i++) {
				current = current.next;
			}
			return current.data;
		}
	}
	
	/**
	 * This method adds the given data to the end of the list.
	 * @param data the element to be added to the list
	 */
	public void addToRear(T data) {
		addItem(size, data);
	}
	
	/**
	 * This method removes the element at the given index from the list.
	 * @param index the index of the element to be removed
	 * @return returns the removed data
	 */
	public T remove(int index) {
		if (index < 0 || index >= size) {
			return null;
		}
		else if (index == 0) {
			Node temp = head;
			head = head.next;
			size--;
			return temp.data;
		}
		else if (index == size - 1) {
			Node current = head;
			for (int i = 0; i < index - 1; i++) {
				current = current.next;
			}
			Node temp = current.next;
			current.next = null;
			size--;
			return temp.data;
		}
		else {
			Node current = head;
			for (int i = 0; i < index - 1; i++) {
				current = current.next;
			}
			Node temp = current.next;
			current.next = current.next.next;
			size--;
			return temp.data;
		}
	}
	
	/**
	 * This method moves the data at the given element ahead in the list one slot.
	 * @param index the index of the element to move forward one
	 */
	public void moveAheadOne(int index) {
		if (!(index <= 1 || index >= size)) {
			Node prev;
			Node temp;
			Node current = head;
			for (int i = 0; i < index - 2; i++) {
				current = current.next;
			}
			prev = current.next;
			temp = prev.next;
			prev.next = temp.next;
			temp.next = prev;
			current.next = temp;
		}
		else if (index == 1) {
			Node prev = head;
			Node temp = head.next;
			prev.next = temp.next;
			temp.next = prev;
			head = temp;
		}
	}
	
	/**
	 * This method returns the size of the list.
	 * @return returns the size of the list
	 */
	public int size() {
		return size;
	}
	
	/**
	 * This class is used by the MultiPurposeList class to keep track of the data in the list.
	 * @author Will
	 *
	 */
	private class Node {
		
		/**
		 * The data of the current Node.
		 */
		public T data;
		
		/**
		 * The next Node in the list.
		 */
		public Node next;
		
		/**
		 * This method constructs a Node object. The field data is set to the given data, and next is set to the
		 * given Node. 
		 * @param data the data of the new Node
		 * @param next the next Node in the list
		 */
		public Node(T data, Node next) {
			this.data = data;
			this.next = next;
		}
	}
}
