/**
 * 
 */
package edu.ncsu.csc216.biosimulation.domain;

/**
 * An abstract class that is designed to keep track of a population count, a birth rate, and
 * a death rate. It has a list of abstract methods that must be implemented in each of its 
 * child classes. 
 * @author Will
 */
public abstract class Species implements Organism {

	/**
	 * The population count for Species.
	 */
	private double count;
	/**
	 * The death rate for the Species.
	 */
	private double deathRate;
	/**
	 * The birth rate for the Species.
	 */
	private double birthRate;
	
	/**
	 * The constructor for Species. It accepts an integer and two doubles. The integer value is 
	 * the population count for the Species while the two doubles are the birth rate and death
	 * rate respectively. 
	 * @param count the population count
	 * @param birthRate the birth rate
	 * @param deathRate the death rate
	 */
	public Species(int count, double birthRate, double deathRate) {
		setCount(count);
		setDeathRate(deathRate);
		setBirthRate(birthRate);
	}

	/**
	 * Sets the population count based on the parameter
	 * @param count the new population count
	 */
	public void setCount(double count) {
		this.count = count;
	}
	
	/**
	 * Sets the birth rate to the value given to the method.
	 * @param birthRate the new birth rate
	 */
	private void setBirthRate(double birthRate) {
		this.birthRate = birthRate;
	}
	
	/**
	 * Used to get the birth rate of the Species.
	 * @return returns birthRate
	 */
	public double getBirthRate() {
		return birthRate;
	}

	/**
	 * Sets the death rate to the value given to the method.
	 * @param deathRate the new death rate
	 */
	private void setDeathRate(double deathRate) {
		this.deathRate = deathRate;
	}
	
	/**
	 * Used to get the death rate of the Species.
	 * @return returns deathRate
	 */
	public double getDeathRate() {
		return deathRate;
	}

	/**
	 * Used to get the count of the Species.
	 * @return returns count
	 */
	public double getCount() {
		return count;
	}
	
	/**
	 * This method is used to find the population value after the next step.
	 * @return returns the future population value
	 */
	public abstract double getProjectedPopulation();
	
	/**
	 * Some child classes keep track of a Predator class. This method will be used to register
	 * the given Species with the current Species.
	 * @param predator the Species that is to be registered
	 */
	public abstract void registerPredator(Species predator);
	
	/**
	 * Some child classes keep track of a Prey class. This method will be used to register the
	 * given Species with the current Species.
	 * @param prey the Species that is to be registered
	 */
	public abstract void registerPrey(Species prey);
	
	/**
	 * This method is used by test classes to determine if the Prey class that is being tracked
	 * by a Species is correct.
	 * @return returns the Prey that the given Species is tracking
	 */
	protected abstract Species getPrey();
	
	/**
	 * This method is used by test classes to determine if the Predator class that is being
	 * tracked by a Species is correct.
	 * @return returns the Predator that the given Species is tracking
	 */
	protected abstract Species getPredator();
}
