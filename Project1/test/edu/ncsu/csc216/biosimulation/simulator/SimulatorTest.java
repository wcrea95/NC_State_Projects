/**
 * 
 */
package edu.ncsu.csc216.biosimulation.simulator;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

/**
 * This class tests the Simulator class. It has methods that are specifically designed to
 * cover almost all of the lines of code. 
 * @author Will
 */
public class SimulatorTest {

	private Simulator simulation;
	/**
	 * This method is called before the rest to help set up some necessary objects that will be
	 * used in every test method.
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		String[] counts = {"10", "250", "400"};
		String[][] parms = {{"0.00068", "0.23"}, {"0.165", "0.0006"}, {"0.000002", "0.1", "0.0006", "0.0003"}};
		simulation = new Simulator(counts, parms);
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.simulator.Simulator#Simulator(java.lang.String[], java.lang.String[][])}.
	 */
	@Test
	public void testSimulator() {
		String[] validCounts = {"10", "250", "400"};
		String[][] validParms = {{"0.00068", "0.23"}, {"0.165", "0.0006"}, {"0.000002", "0.1", "0.0006", "0.0003"}};
		String[] invalidCounts1 = {"-5", "250", "400"};
		String[] invalidCounts2 = {"10", "250", "apples"};
		String[][] invalidParms1 = {{"0.00068", "0.23"}, {"0.165", "0.0006"}, {"0.002", "1.5", "0", "0"}};
		String[][] invalidParms2 = {{"0.00068", "0.23"}, {"0.165", "apples"}, {"0.2", "0.1", "0.6", "0.3"}};
		Simulator simulation1 = new Simulator(validCounts, validParms);
		
		for (int i = 0; i < Simulator.getDefaultInitialCounts().length; i++) {
			assertEquals(Simulator.getDefaultInitialCounts()[i], simulation1.getPopulations()[i]);
		}
		
		try {
			Simulator simulation2 = new Simulator(invalidCounts1, validParms);
			simulation2.getPopulations();
			fail();
		} catch (IllegalArgumentException e) {
			assertEquals("Population counts cannot be negative.", e.getMessage());
		}
		
		try {
			Simulator simulation3 = new Simulator(invalidCounts2, validParms);
			simulation3.getPopulations();
			fail();
		} catch (IllegalArgumentException e) {
			assertEquals("Initial population counts must be integers.", e.getMessage());
		}
		
		try {
			Simulator simulation4 = new Simulator(validCounts, invalidParms1);
			simulation4.getPopulations();
			fail();
		} catch (IllegalArgumentException e) {
			assertEquals("Birth/death rates must be between 0 and 1.", e.getMessage());
		}
		
		try {
			Simulator simulation5 = new Simulator(validCounts, invalidParms2);
			simulation5.getPopulations();
			fail();
		} catch (IllegalArgumentException e) {
			assertEquals("Birth/death rates must be numbers.", e.getMessage());
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.simulator.Simulator#getDefaultParameters()}.
	 */
	@Test
	public void testGetDefaultParameters() {
		double[][] expected = 	{{0.00068, 0.23},
								{0.165, 0.0006},
								{0.000002, 0.1, 0.0006, 0.0003}};
		double[][] actual = Simulator.getDefaultParameters();
		
		for (int i = 0; i < expected.length; i++) {
			for (int j = 0; j < expected[i].length; j++) {
				assertEquals(expected[i][j], actual[i][j], 0);
			}
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.simulator.Simulator#getDefaultInitialCounts()}.
	 */
	@Test
	public void testGetDefaultInitialCounts() {
		int[] expected = {10, 250, 400};
		int[] actual = Simulator.getDefaultInitialCounts();
		
		for (int i = 0; i < expected.length; i++) {
			assertEquals(expected[i], actual[i]);
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.simulator.Simulator#getPopulations()}.
	 */
	@Test
	public void testGetPopulations() {
		int[] expected = {10, 250, 400};
		int[] actual = simulation.getPopulations();
		
		for (int i = 0; i < expected.length; i++) {
			assertEquals(expected[i], actual[i]);
		}
	}

	/**
	 * Test method for {@link edu.ncsu.csc216.biosimulation.simulator.Simulator#step()}.
	 */
	@Test
	public void testStep() {
		int[] expectedAfterOneStep = new int[3];
		expectedAfterOneStep[0] = (int) (Math.ceil(10 - 0.23 * 10 + 0.00068 * 10 * 250));
		expectedAfterOneStep[1] = (int) (Math.ceil(250 + .165 * 250 - 250 * 10 * 0.0006));
		expectedAfterOneStep[2] = (int) (Math.ceil(400 - 0.1 * 400 + 400 * 250 * 10 * 0.000002 + 250 * 400 * 
				0.0006 + 10 * 400 * 0.0003 - .001 * 400 * 400));
		simulation.step();
		int[] actualAfterOneStep = simulation.getPopulations();
		
		for (int i = 0; i < expectedAfterOneStep.length; i++) {
			assertEquals(expectedAfterOneStep[i], actualAfterOneStep[i]);
		}
		
		int[] expectedAfterSixHundredSteps = {244, 343, 334};
		for (int i = 1; i < 600; i++) {
			simulation.step();
		}
		int[] actualAfterSixHundredSteps = simulation.getPopulations();
		
		for (int i = 0; i < expectedAfterSixHundredSteps.length; i++) {
			assertEquals(expectedAfterSixHundredSteps[i], actualAfterSixHundredSteps[i]);
		}
	}

}
