package robosim.ai;

import robosim.core.Action;
import robosim.core.Simulator;

public class BasicAvoider implements Controller {
	@Override
	public void control(Simulator sim) {
	        System.out.println(sim.findClosest());
		if (sim.wasHit() || sim.findClosest() < 30) {
			Action.LEFT.applyTo(sim);
		} else {
			Action.FORWARD.applyTo(sim);
		}
	}
}
