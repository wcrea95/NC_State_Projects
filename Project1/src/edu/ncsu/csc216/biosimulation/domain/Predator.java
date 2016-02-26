/**
 * 
 */
package edu.ncsu.csc216.biosimulation.domain;

/**
 * The Predator class is a child class of the Species class. It has methods that allow it to update 
 * its population with a specific formula. The poulation can never be bellow MIN_PREDATOR and can 
 * never be above MAX_PREDATOR. Predator also keeps track of its Prey.
 * @author Will
 */
public class Predator extends Species {

	/**
	 * The maximum population value that Predator can have.
	 */
	public static final int MAX_PREDATOR = 300;
	/**
	 * The minimum population value that Predator can have.
	 */
	public static final int MIN_PREDATOR = 0;
	/**
	 * The default birth and death rates for Predator.
	 */
	private static final double[] DEFAULTS = {0.00068, 0.23};
	
	/**
	 * The Prey class that Predator hunts.
	 */
	private Species food;

	/**
	 * The constructor for the Predator class. It calls the Species constructor and passes the
	 * parameters given to it to the Species constructor. Then it checks if the population count
	 * is within the given range.
	 * @param count the initial population count
	 * @param birthRate the birth rate for the Predator
	 * @param deathRate the death rate for the Predator
	 */
	public Predator(int count, double birthRate, double deathRate) {
		super(count, birthRate, deathRate);
		
		if (super.getCount() > MAX_PREDATOR) {
			super.setCount(MAX_PREDATOR);
		}
		if (super.getCount() < MIN_PREDATOR) {
			super.setCount(MIN_PREDATOR);
		}
	}

	/**
	 * A static method that can be called by any class to get the default birth and death rates.
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
		// dy/dt = -cy + pxy
		// x = prey count
		// y = predator count
		// c = predator death rate
		// p = predator birth rate
		double x = food.getCount();
		double y = super.getCount();
		double c = super.getDeathRate();
		double p = super.getBirthRate();
		
		double change = (p * x * y) - (c * y);
		double futureCount = y + change;
		
		if (futureCount > MAX_PREDATOR) {
			return MAX_PREDATOR;
		}
		if (futureCount < MIN_PREDATOR) {
			return MIN_PREDATOR;
		}

		return futureCount;
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#registerPredator(edu.ncsu.csc216.biosimulation.domain.Species)
	 */
	@Override
	public void registerPredator(Species predator) {
		//Unused method. Predator objects keep track of themselves.
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#registerPrey(edu.ncsu.csc216.biosimulation.domain.Species)
	 */
	@Override
	public void registerPrey(Species prey) {
		food = prey;
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#getPrey()
	 */
	@Override
	protected Species getPrey() {
		return food;
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#getPredator()
	 */
	@Override
	protected Species getPredator() {
		return this;
	}

}
