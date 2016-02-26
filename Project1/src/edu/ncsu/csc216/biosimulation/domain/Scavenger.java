/**
 * 
 */
package edu.ncsu.csc216.biosimulation.domain;

/**
 * The Scavenger class is a child class of the Species class. It has methods that allow it to update 
 * its population with a specific formula. The poulation can never be bellow MIN_SCAVENGER and can 
 * never be above MAX_SCAVENGER. Scavenger also keeps track of the Prey and the Predator.
 * @author Will
 */
public class Scavenger extends Species {

	/**
	 * The maximum population that Scavenger can have.
	 */
	public static final int MAX_SCAVENGER = 500;
	/**
	 * The minimum population that Scavenger can have.
	 */
	public static final int MIN_SCAVENGER = 4;
	/**
	 * The default birth and death rates for Scavenger.
	 */
	private static final double[] DEFAULTS = {0.000002, 0.1, 0.0006, 0.0003};
	
	/**
	 * The birth rate from preyCarcass.
	 */
	private double preyCarcassBirthRate;
	/**
	 * The birth rate from predatorCarcass.
	 */
	private double predatorCarcassBirthRate;
	/**
	 * The limiting factor for Scavenger.
	 */
	private static final double LIMITING_FACTOR = 0.001;
	
	/**
	 * The Prey that Scavenger sometimes eats.
	 */
	private Species preyCarcass;
	/**
	 * The Predator that Scavenger sometimes eats.
	 */
	private Species predatorCarcass;
	
	/**
	 * The constructor for the Scavenger class. It calls the Species constructor and passes the
	 * parameters given to it to the Species constructor. Then it checks if the population count
	 * is within the given range.
	 * @param count the initial population count
	 * @param birthRate the birth rate for the Scavenger
	 * @param deathRate the death rate for the Scavenger
	 * @param preyCarcassBirthRate the birth rate from the Prey carcass
	 * @param predatorCarcassBirthRate the birth rate from the Predator carcass
	 */
	public Scavenger(int count, double birthRate, double deathRate, double preyCarcassBirthRate, 
			double predatorCarcassBirthRate) {
		super(count, birthRate, deathRate);
		setPreyCarcassBirthRate(preyCarcassBirthRate);
		setPredatorCarcassBirthRate(predatorCarcassBirthRate);
		
		if (super.getCount() > MAX_SCAVENGER) {
			super.setCount(MAX_SCAVENGER);
		}
		if (super.getCount() < MIN_SCAVENGER) {
			super.setCount(MIN_SCAVENGER);
		}
	}

	/**
	 * A static method that can be called by any class to find the default parameters.
	 * @return returns DEFAULTS
	 */
	public static double[] getDefaultParameters() {
		return DEFAULTS;
	}
	
	/**
	 * Sets the preyCarcassBirthRate for the class.
	 * @param preyCarcassBirthRate the preyCarcassBirthRate to set
	 */
	private void setPreyCarcassBirthRate(double preyCarcassBirthRate) {
		this.preyCarcassBirthRate = preyCarcassBirthRate;
	}

	/**
	 * Sets the predatorCarcassBirthRate for the class.
	 * @param predatorCarcassBirthRate the predatorCarcassBirthRate to set
	 */
	private void setPredatorCarcassBirthRate(double predatorCarcassBirthRate) {
		this.predatorCarcassBirthRate = predatorCarcassBirthRate;
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#getProjectedPopulation()
	 */
	@Override
	public double getProjectedPopulation() {
		// dz/dt = -ez + fxyz +gxz + hyz - iz^2
		// x = prey count
		// y = predator count
		// z = scavenger count
		// e = scavenger death rate
		// f = scavenger birth rate from kills 
		// g = scavenger birth rate from prey
		// h = scavenger birth rate from predators
		// i = scavenger limiting factor		
		double x = preyCarcass.getCount();
		double y = predatorCarcass.getCount();
		double z = super.getCount();
		double e = super.getDeathRate();
		double f = super.getBirthRate();
		double g = preyCarcassBirthRate;
		double h = predatorCarcassBirthRate;
		
		double change = (f * x * y * z) - (e * z) + (g * x * z) + (h * y * z) - (LIMITING_FACTOR * z * z);
		double futureCount = z + change;
		
		if (futureCount > MAX_SCAVENGER) {
			return MAX_SCAVENGER;
		}
		if (futureCount < MIN_SCAVENGER) {
			return MIN_SCAVENGER;
		}
	
		return futureCount;
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#registerPredator(edu.ncsu.csc216.biosimulation.domain.Species)
	 */
	@Override
	public void registerPredator(Species predator) {
		this.predatorCarcass = predator;
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#registerPrey(edu.ncsu.csc216.biosimulation.domain.Species)
	 */
	@Override
	public void registerPrey(Species prey) {
		this.preyCarcass = prey;
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#getPrey()
	 */
	@Override
	protected Species getPrey() {
		return preyCarcass;
	}

	/* (non-Javadoc)
	 * @see edu.ncsu.csc216.biosimulation.domain.Species#getPredator()
	 */
	@Override
	protected Species getPredator() {
		return predatorCarcass;
	}

}