/**
 * 
 */
package edu.ncsu.csc216.biosimulation.domain;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

import edu.ncsu.csc216.biosimulation.simulator.Simulator;

/**
 * The PreyTest class tests the Prey class. It has methods that will cover almost every line
 * of code in Prey.
 * @author Will
 */
public class PreyTest {

	private Species victim;
	private Species killer;
	/**
	 * This method is called before all of the other methods to make sure that some common variables
	 * used by every method are instantiated.
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		victim = new Prey(Simulator.getDefaultInitialCounts()[1], Prey.getDefaultParameters()[0], 
				Prey.getDefaultParameters()[1]);
		killer = new Predator(Simulator.getDefaultInitialCounts()[0], Predator.getDefaultParameters()[0], 
				Predator.getDefaultParameters()[1]);
		victim.registerPredator(killer);
		killer.registerPrey(victim);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Prey#getProjectedPopulation()}.
	 */
	@Test
	public void testGetProjectedPopulation() {
		assertTrue(victim.getCount() == Simulator.getDefaultInitialCounts()[1]);
		
		double x = victim.getCount();
		double a = victim.getBirthRate();
		double b = victim.getDeathRate();
		double y = victim.getPredator().getCount();
		assertTrue(victim.getProjectedPopulation() == x  + (a * x - b * x * y));
		
		assertTrue(victim.getCount() == Simulator.getDefaultInitialCounts()[1]);
		
		Prey victim1 = new Prey(Prey.MAX_PREY, Prey.getDefaultParameters()[0], Prey.getDefaultParameters()[1]);
		victim1.registerPredator(killer);
		assertTrue(victim1.getProjectedPopulation() == Prey.MAX_PREY);
		
		Prey victim2 = new Prey(Prey.MIN_PREY + 1, .0001, .9);
		victim2.registerPredator(killer);
		assertTrue(victim2.getProjectedPopulation() == Prey.MIN_PREY);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Prey#registerPredator(edu.ncsu.csc216.biosimulation.domain.Species)}.
	 */
	@Test
	public void testRegisterPredator() {
		Prey victim1 = new Prey(Simulator.getDefaultInitialCounts()[1], Prey.getDefaultParameters()[0], 
				Prey.getDefaultParameters()[1]);
		Predator killer1 = new Predator(Simulator.getDefaultInitialCounts()[0], Predator.getDefaultParameters()[0], 
				Predator.getDefaultParameters()[1]);
		
		assertNull(victim1.getPredator());
		
		victim1.registerPredator(killer1);
		assertEquals(victim1.getPredator(), killer1);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Prey#registerPrey(edu.ncsu.csc216.biosimulation.domain.Species)}.
	 */
	@Test
	public void testRegisterPrey() {
		Prey victim1 = new Prey(Simulator.getDefaultInitialCounts()[1], Prey.getDefaultParameters()[0], 
				Prey.getDefaultParameters()[1]);
		
		victim1.registerPrey(victim1);
		assertEquals(victim1.getPrey(), victim1);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Prey#Prey(int, double, double)}.
	 */
	@Test
	public void testPrey() {
		Prey victim1 = new Prey(Simulator.getDefaultInitialCounts()[1], Prey.getDefaultParameters()[0], 
				Prey.getDefaultParameters()[1]);
		assertEquals(victim1.getPrey(), victim1);
		assertTrue(victim1.getCount() == Simulator.getDefaultInitialCounts()[1]);
		assertTrue(victim1.getBirthRate() == Prey.getDefaultParameters()[0]);
		assertTrue(victim1.getDeathRate() == Prey.getDefaultParameters()[1]);
		
		Prey victim2 = new Prey(Prey.MAX_PREY + 1, Prey.getDefaultParameters()[0], 
				Prey.getDefaultParameters()[1]);
		assertTrue(victim2.getCount() == Prey.MAX_PREY);
		
		Prey victim3 = new Prey(Prey.MIN_PREY - 1, Prey.getDefaultParameters()[0], 
				Prey.getDefaultParameters()[1]);
		assertTrue(victim3.getCount() == Prey.MIN_PREY);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Prey#getDefaultParameters()}.
	 */
	@Test
	public void testGetDefaultParameters() {
		assertTrue(Prey.getDefaultParameters()[0] == Simulator.getDefaultParameters()[1][0]);
		assertTrue(Prey.getDefaultParameters()[1] == Simulator.getDefaultParameters()[1][1]);
	}

}
