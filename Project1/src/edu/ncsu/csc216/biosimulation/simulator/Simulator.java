/**
 * 
 */
package edu.ncsu.csc216.biosimulation.simulator;

import edu.ncsu.csc216.biosimulation.domain.Predator;
import edu.ncsu.csc216.biosimulation.domain.Prey;
import edu.ncsu.csc216.biosimulation.domain.Scavenger;
import edu.ncsu.csc216.biosimulation.domain.Species;

/**
 * The simulator class is used by SimulatorGUI to run the predator prey system. This class keeps 
 * track of a Predator, its Prey, and a Scavenger. When the object is created each of the three 
 * different species is created using the given parameters. The constructor is passed two arrays 
 * of Strings which contain the initial population counts as well as all the initial birth and 
 * death rates.
 * @author Will Rea
 */
public class Simulator {
	
	/**
	 * Default initial population counts.
	 */
	private static final int[] DEFAULT_INITIAL_COUNT = {10, 250, 400};
	/**
	 * Default initial birth and death rates.
	 */
	private static final double[][] DEFAULT_PARAMETERS = 	{{0.00068, 0.23},
														 	 {0.165, 0.0006},
														 	 {0.000002, 0.1, 0.0006, 0.0003}};
	/**
	 * The minimum amount that a rate can be.
	 */
	private static final double MIN_RATE = 0;
	/**
	 * The maximum amount that a rate can be. 
	 */
	private static final double MAX_RATE = 1;
	
	/**
	 * The list of birth and death rates.
	 */
	private double[][] speciesParameters;
	/**
	 * The list of population counts.
	 */
	private int[] population;
	
	/**
	 * The Predator for the simulation.
	 */
	private Species victim;
	/**
	 * The Prey for the simulation.
	 */
	private Species killer;
	/**
	 * The Scavenger for the simulation.
	 */
	private Species scrounger;
	
	/**
	 * Creates a Simulator object. This uses the helper methods readCounts(), validateCounts(), 
	 * readParms(), validateParms(), and instantiateSpecies(). This method is given a one
	 * dimensional array of the original population counts and a two dimensional array which 
	 * contains all of the birth and death rates for the different Species.
	 * @param counts the initial population counts
	 * @param parms the birth and death rates of the species
	 */
	public Simulator(String[] counts, String[][] parms) {
		readCounts(counts);
		validateCounts();
		
		speciesParameters = new double[parms.length][];
		for(int i = 0; i < parms.length; i++) {
			speciesParameters[i] = readParms(parms[i]);
		}
		for(int i = 0; i < speciesParameters.length; i++) {
			validateParms(speciesParameters[i]);
		}
		
		instantiateSpecies();
	}
	
	/**
	 * Static method used to get the default rates of the different Species.
	 * @return returns DEFAULT_PARAMETERS
	 */
	public static double[][] getDefaultParameters() {
		return DEFAULT_PARAMETERS;
	}
	
	/**
	 * Static method used to get the default population counts
	 * @return returns DEFAULT_INITIAL_COUNT
	 */
	public static int[] getDefaultInitialCounts() {
		return DEFAULT_INITIAL_COUNT;
	}
	
	/**
	 * This method is a helper method for the constructor. It looks at all the values 
	 * for the initial population counts and checks to see that they are above zero.
	 */
	private void validateCounts() {
		if (population[0] < Predator.MIN_PREDATOR) {
			throw new IllegalArgumentException("Population counts cannot be negative.");
		}
		if (population[1] < Prey.MIN_PREY) {
			throw new IllegalArgumentException("Population counts cannot be negative.");
		}
		if (population[2] < 0) {
			throw new IllegalArgumentException("Population counts cannot be negative.");
		}
	}
	
	/**
	 * This method is a helper method for the constructor. It looks at the array of Strings
	 * given to it by the constructor and turns it in to an array of integers. 
	 * @param counts
	 */
	private void readCounts(String[] counts) {
		population = new int[counts.length];
		for (int i = 0; i < counts.length; i++) {
			try {
				population[i] = Integer.parseInt(counts[i]);
			} catch (IllegalArgumentException e) {
				throw new IllegalArgumentException("Initial population counts must be integers.");
			}
		}
	}
	
	/**
	 * This method is a helper method for the constructor. It looks at an array of Strings
	 * given to it by the constructor and turns it in to an array of doubles. The first number
	 * in the array is the birth rate for the Species and the second is the death rate.
	 * @param unreadParms the array of Strings that needs to be changed in to an array of doubles
	 * @return returns the array of doubles that contains the rates for a Species
	 */
	private double[] readParms(String[] unreadParms) {
		double[] parms = new double[unreadParms.length];
		for (int i = 0; i < unreadParms.length; i++) {
			try {
				parms[i] = Double.parseDouble(unreadParms[i]);
			} catch (IllegalArgumentException e) {
				throw new IllegalArgumentException("Birth/death rates must be numbers.");
			}
		}
		return parms;
	}
	
	/**
	 * This method is a helper method for the constructor. It looks at an array of doubles
	 * and checks to see if all of the members in that array are between one and zero. 
	 * @param parms the list of rates for a Species
	 */
	private void validateParms(double[] parms) {
		for (int i = 0; i < parms.length; i++) {
			if (parms[i] < MIN_RATE || parms[i] > MAX_RATE) {
				throw new IllegalArgumentException("Birth/death rates must be between 0 and 1.");
			}
		}
	}
	
	/**
	 * This method is a helper method for the constructor. It builds the different Species
	 * objects with the initial population counts and rates given to Simulator in the constructor.
	 */
	private void instantiateSpecies() {
		victim = new Prey(population[1], speciesParameters[1][0], speciesParameters[1][1]);
		killer = new Predator(population[0], speciesParameters[0][0], speciesParameters[0][1]);
		scrounger = new Scavenger(population[2], speciesParameters[2][0], speciesParameters[2][1], 
				speciesParameters[2][2], speciesParameters[2][3]);
		victim.registerPredator(killer);
		killer.registerPrey(victim);
		scrounger.registerPredator(killer);
		scrounger.registerPrey(victim);
	}
	
	/**
	 * Returns an array of integers that contains the populations of each of the different Species.
	 * @return returns population
	 */
	public int[] getPopulations() {
		return population;
	}
	
	/**
	 * This method is used to increase or decrease the populations of each type of Species. To
	 * find the future population of each Species the getProjectedPopulation() method is called.
	 * The population array is updated and each Species is updated with the new population.
	 */
	public void step() {
		double killerFuturePopulation = killer.getProjectedPopulation();
		double victimFuturePopulation = victim.getProjectedPopulation();
		double scroungerFuturePopulation = scrounger.getProjectedPopulation();
		
		population[0] =  (int) (Math.ceil(killerFuturePopulation));
		population[1] = (int) (Math.ceil(victimFuturePopulation));
		population[2] = (int) (Math.ceil(scroungerFuturePopulation));
		
		killer.setCount(killerFuturePopulation);
		victim.setCount(victimFuturePopulation);
		scrounger.setCount(scroungerFuturePopulation);
	}
}