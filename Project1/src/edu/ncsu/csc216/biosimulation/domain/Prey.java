/**
 * 
 */
package edu.ncsu.csc216.biosimulation.domain;

/**
 * The Prey class is a child class of the Species class. It has methods that 
 * allow it to update its population with a specific formula. The poulation can 
 * never be bellow MIN_PREY and can never be above MAX_PREY. Prey also keeps
 * track of its predator.
 * @author Will
 */
public class Prey extends Species {

	/**
	 * The maximum amount the population can be.
	 */
	public static final int MAX_PREY = 500;
	/**
	 * The minimum amount the population can be.
	 */
	public static final int MIN_PREY = 0;
	/**
	 * The default birth and death rate for a Prey class.
	 */
	private static final double[] DEFAULTS = {0.165, 0.0006};
	
	/**
	 * The Predator class for this Prey.
	 */
	private Species killer;
	
	/**
	 * The constructor for Prey calls the Species constructor. Then it checks if the initial
	 * population to see if it is within the given range. 
	 * @param count the initial population count
	 * @param birthRate the birth rate for this class
	 * @param deathRate the death rate for this class
	 */
	public Prey(int count, double birthRate, double deathRate) {
		super(count, birthRate, deathRate);
		
		if (super.getCount() > MAX_PREY) {
			super.setCount(MAX_PREY);
		}
		if (super.getCount() < MIN_PREY) {
			super.setCount(MIN_PREY);
		}
	}
	
	/**
	 * A static method that can be called by any class to find the default parameters.
	 * @return returns DEFAULTS
	 */
	public static double[] getDefaultParameters() {
		return DEFAULTS;
	}
	
	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#getProjectedPopulation()
	 */
	@Override
	public double getProjectedPopulation() {
		// dx/dt = ax - bxy
		// x = prey count
		// a = prey birth rate
		// b = prey death rate
		// y = predator count
		double x = super.getCount();
		double a = super.getBirthRate();
		double b = super.getDeathRate();
		double y = killer.getCount();
		
		double change = (a * x) - (b * x * y);
		double futureCount = x + change;
		
		if (futureCount > MAX_PREY) {
			return MAX_PREY;
		}
		if (futureCount < MIN_PREY) {
			return MIN_PREY;
		}

		return futureCount;
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#registerPredator(edu.ncsu.csc216.biosimulation.domain.Species)
	 */
	@Override
	public void registerPredator(Species predator) {
		killer = predator;
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#registerPrey(edu.ncsu.csc216.biosimulation.domain.Species)
	 */
	@Override
	public void registerPrey(Species prey) {
		//Unused method. Prey objects already keep track of themselves.
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#getPrey()
	 */
	@Override
	protected Species getPrey() {
		return this;
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#getPredator()
	 */
	@Override
	protected Species getPredator() {
		return killer;
	}
}