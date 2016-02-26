/**
 * 
 */
package edu.ncsu.csc216.biosimulation.domain;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

import edu.ncsu.csc216.biosimulation.simulator.Simulator;

/**
 * This class will test the Predator class. It has methods that will cover almost all lines of 
 * code in Predator.
 * @author Will
 */
public class PredatorTest {

	private Prey victim;
	private Predator killer;

	/**
	 * This method is called before all other methods and helps set up some variables that will
	 * be used by all of the other methods.
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
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Predator#getProjectedPopulation()}.
	 */
	@Test
	public void testGetProjectedPopulation() {
		assertTrue(killer.getCount() == Simulator.getDefaultInitialCounts()[0]);
		
		double x = killer.getPrey().getCount();
		double y = killer.getCount();
		double c = killer.getDeathRate();
		double p = killer.getBirthRate();
		assertEquals(y + (p * x * y - c * y), killer.getProjectedPopulation(), 0.000001);
		
		assertTrue(killer.getCount() == Simulator.getDefaultInitialCounts()[0]);
		
		Predator killer1 = new Predator(Predator.MAX_PREDATOR, 0.9, 0.001);
		killer1.registerPrey(victim);
		assertEquals(killer1.getProjectedPopulation(), Predator.MAX_PREDATOR, 0);
		
		Predator killer2 = new Predator(Predator.MIN_PREDATOR + 1, 0.00001, 1.5);
		Prey victim1 = new Prey(Prey.MIN_PREY, Prey.getDefaultParameters()[0], 
				Prey.getDefaultParameters()[1]);
		killer2.registerPrey(victim1);
		assertEquals(Predator.MIN_PREDATOR, killer2.getProjectedPopulation(), 0);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Predator#registerPredator(edu.ncsu.csc216.biosimulation.domain.Species)}.
	 */
	@Test
	public void testRegisterPredator() {
		Predator killer1 = new Predator(Simulator.getDefaultInitialCounts()[0], 
				Predator.getDefaultParameters()[0], Predator.getDefaultParameters()[1]);
		
		killer1.registerPredator(killer);
		assertEquals(killer1.getPredator(), killer1);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Predator#registerPrey(edu.ncsu.csc216.biosimulation.domain.Species)}.
	 */
	@Test
	public void testRegisterPrey() {
		Predator killer1 = new Predator(Simulator.getDefaultInitialCounts()[0], 
				Predator.getDefaultParameters()[0], Predator.getDefaultParameters()[1]);
		
		assertNull(killer1.getPrey());
		killer1.registerPrey(victim);
		assertEquals(killer1.getPrey(), victim);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Predator#Predator(int, double, double)}.
	 */
	@Test
	public void testPredator() {
		Predator killer1 = new Predator(Simulator.getDefaultInitialCounts()[1], 
				Predator.getDefaultParameters()[0], Predator.getDefaultParameters()[1]);
		assertEquals(killer1.getPredator(), killer1);
		assertTrue(killer1.getCount() == Simulator.getDefaultInitialCounts()[1]);
		assertTrue(killer1.getBirthRate() == Predator.getDefaultParameters()[0]);
		assertTrue(killer1.getDeathRate() == Predator.getDefaultParameters()[1]);
		
		Predator killer2 = new Predator(Predator.MAX_PREDATOR + 1, Predator.getDefaultParameters()[0], 
				Predator.getDefaultParameters()[1]);
		assertTrue(killer2.getCount() == Predator.MAX_PREDATOR);
		
		Predator killer3 = new Predator(Predator.MIN_PREDATOR - 1, Predator.getDefaultParameters()[0], 
				Predator.getDefaultParameters()[1]);
		assertTrue(killer3.getCount() == Predator.MIN_PREDATOR);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Predator#getDefaultParameters()}.
	 */
	@Test
	public void testGetDefaultParameters() {
		assertEquals(Predator.getDefaultParameters()[0], Simulator.getDefaultParameters()[0][0], 0);
		assertEquals(Predator.getDefaultParameters()[1], Simulator.getDefaultParameters()[0][1], 0);
	}

}
