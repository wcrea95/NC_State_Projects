/**
 * 
 */
package edu.ncsu.csc216.biosimulation.domain;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

import edu.ncsu.csc216.biosimulation.simulator.Simulator;

/**
 * This class tests the Scavenger class. It will test all of its method and covers almost every
 * line of code in Scavenger.
 * @author Will
 */
public class ScavengerTest {

	private Species victim;
	private Species killer;
	private Species scrounger;
	/**
	 * This method is called before every method to set up certain variables that will be used by
	 * every test method.
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		victim = new Prey(Simulator.getDefaultInitialCounts()[1], Prey.getDefaultParameters()[0], 
				Prey.getDefaultParameters()[1]);
		killer = new Predator(Simulator.getDefaultInitialCounts()[0], Predator.getDefaultParameters()[0], 
				Predator.getDefaultParameters()[1]);
		scrounger = new Scavenger(Simulator.getDefaultInitialCounts()[2], Scavenger.getDefaultParameters()[0], 
				Scavenger.getDefaultParameters()[1], Scavenger.getDefaultParameters()[2], 
				Scavenger.getDefaultParameters()[3]);
		victim.registerPredator(killer);
		killer.registerPrey(killer);
		scrounger.registerPredator(killer);
		scrounger.registerPrey(victim);		
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Scavenger#getProjectedPopulation()}.
	 */
	@Test
	public void testGetProjectedPopulation() {
		assertTrue(scrounger.getCount() == Simulator.getDefaultInitialCounts()[2]);
		
		double x = scrounger.getPrey().getCount();
		double y = scrounger.getPredator().getCount();
		double z = scrounger.getCount();
		double e = scrounger.getDeathRate();
		double f = scrounger.getBirthRate();
		double g = Scavenger.getDefaultParameters()[2];
		double h = Scavenger.getDefaultParameters()[3];
		double i = .001;
		
		assertTrue(scrounger.getProjectedPopulation() == z - e * z + f * x * y * z + g * x * z + h * 
		y * z - i * z * z);
		
		Scavenger scrounger1 = new Scavenger(Scavenger.MAX_SCAVENGER, .9,
				Scavenger.getDefaultParameters()[1], Scavenger.getDefaultParameters()[2], 
				Scavenger.getDefaultParameters()[3]);
		scrounger1.registerPredator(killer);
		scrounger1.registerPrey(victim);
		assertTrue(scrounger1.getProjectedPopulation() == Scavenger.MAX_SCAVENGER);
		
		Scavenger scrounger2 = new Scavenger(Scavenger.MIN_SCAVENGER, Scavenger.getDefaultParameters()[0],
				.9, Scavenger.getDefaultParameters()[2], Scavenger.getDefaultParameters()[3]);
		scrounger2.registerPredator(killer);
		scrounger2.registerPrey(victim);
		assertTrue(scrounger2.getProjectedPopulation() == Scavenger.MIN_SCAVENGER);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Scavenger#registerPredator(edu.ncsu.csc216.biosimulation.domain.Species)}.
	 */
	@Test
	public void testRegisterPredator() {
		Scavenger scrounger1 = new Scavenger(Simulator.getDefaultInitialCounts()[2], 
				Scavenger.getDefaultParameters()[0], Scavenger.getDefaultParameters()[1], 
				Scavenger.getDefaultParameters()[2], Scavenger.getDefaultParameters()[3]);
		assertNull(scrounger1.getPredator());
		
		scrounger1.registerPredator(killer);
		assertEquals(scrounger1.getPredator(), killer);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Scavenger#registerPrey(edu.ncsu.csc216.biosimulation.domain.Species)}.
	 */
	@Test
	public void testRegisterPrey() {
		Scavenger scrounger1 = new Scavenger(Simulator.getDefaultInitialCounts()[2], 
				Scavenger.getDefaultParameters()[0], Scavenger.getDefaultParameters()[1], 
				Scavenger.getDefaultParameters()[2], Scavenger.getDefaultParameters()[3]);
		assertNull(scrounger1.getPrey());
		
		scrounger1.registerPrey(victim);
		assertEquals(scrounger1.getPrey(), victim);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Scavenger#Scavenger(int, double, double, double, double)}.
	 */
	@Test
	public void testScavenger() {
		assertTrue(scrounger.getCount() == Simulator.getDefaultInitialCounts()[2]);
		assertTrue(scrounger.getBirthRate() == Scavenger.getDefaultParameters()[0]);
		assertTrue(scrounger.getDeathRate() == Scavenger.getDefaultParameters()[1]);
		
		Scavenger scrounger1 = new Scavenger(Scavenger.MAX_SCAVENGER + 1, Scavenger.getDefaultParameters()[0], 
				Scavenger.getDefaultParameters()[1], Scavenger.getDefaultParameters()[2], 
				Scavenger.getDefaultParameters()[3]);
		assertNull(scrounger1.getPrey());
		assertNull(scrounger1.getPredator());
		assertTrue(scrounger1.getCount() == Scavenger.MAX_SCAVENGER);
		
		Scavenger scrounger2 = new Scavenger(Scavenger.MIN_SCAVENGER - 1, Scavenger.getDefaultParameters()[0], 
				Scavenger.getDefaultParameters()[1], Scavenger.getDefaultParameters()[2], 
				Scavenger.getDefaultParameters()[3]);
		assertTrue(scrounger2.getCount() == Scavenger.MIN_SCAVENGER);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.domain.Scavenger#getDefaultParameters()}.
	 */
	@Test
	public void testGetDefaultParameters() {
		assertTrue(Scavenger.getDefaultParameters()[0] == Simulator.getDefaultParameters()[2][0]);
		assertTrue(Scavenger.getDefaultParameters()[1] == Simulator.getDefaultParameters()[2][1]);
		assertTrue(Scavenger.getDefaultParameters()[2] == Simulator.getDefaultParameters()[2][2]);
		assertTrue(Scavenger.getDefaultParameters()[3] == Simulator.getDefaultParameters()[2][3]);
	}

}
