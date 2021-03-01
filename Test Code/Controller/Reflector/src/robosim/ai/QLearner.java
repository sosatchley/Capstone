package robosim.ai;

import robosim.core.Action;
import robosim.core.Simulator;

public class QLearner implements Controller {
        
        double[][] QTable;
        int[][] visits;
        double gamma = 0.5;
        double alpha = 1.0;
        int count = 0;


        @Override
        public void control(Simulator sim) {
                if (count < 1) {
                        initializeTable();
                }
                count++;
                double distance = sim.findClosest();
                int state = getState(distance, sim);
                double reward = getReward(state);
                int action = pickMaxAction(state);
                int statePrime = applyAction(action, sim);
                double update = (1-alpha) * rewardFromTable(state, action) + alpha*(reward + gamma * pickMaxAction(statePrime));
                updateTable(state, action, update);
                for (int j = 0; j < QTable.length; j++) {
                        for (int i = 0; i < QTable[j].length; i++) {
                                System.out.print("[" + visits[j][i] + "]");
                        }
                        System.out.println("");                                
                }
                System.out.println("---------");
                state = statePrime;
        }
        
        private void initializeTable() {
                double random = Math.random();
                QTable = new double[5][4];
                visits = new int[5][4];
                for (int i = 0; i < QTable.length; i++) {
                        for (int j = 0; j < QTable[i].length; j++) {
                                QTable[i][j] = random;
                                visits[i][j] = 0;
                        }
                }
        }
        
        private int applyAction(int index, Simulator sim) {
                switch(index) {
                case 0:
                        Action.FORWARD.applyTo(sim);
                        break;
                case 1:
                        Action.RIGHT.applyTo(sim);
                        break;
                case 2:
                        Action.LEFT.applyTo(sim);
                        break;
                case 3:
                        Action.BACKWARD.applyTo(sim);
                        break;
                }
                double distance = sim.findClosest();
                return getState(distance, sim);
        }

        private int pickAction(int state) {
                if (state == 4) {
                        return 1;
                }
                double best = 0.0;
                int index = 0;
                for (int i = 0; i < QTable[state].length; i++) {
                        if (QTable[state][i] > best) {
                                best = QTable[state][i];
                                index = i;
                        }
                }
                visits[state][index] += 1;
                return index;
        }
        
        private int pickMaxAction(int state) {
                double best = 0.0;
                int index = 0;
                for (int i = 0; i < QTable[state].length; i++) {
                        if (QTable[state][i] > best) {
                                best = QTable[state][i];
                                index = i;
                        }
                }
                visits[state][index] += 1;
                return index;
                
        }
        
        private int getState(double distance, Simulator sim) {
                if (sim.isColliding()) {
                        return 4;
                } else if (distance > 10 && distance < 20) {
                        return 0;
                } else if (distance > 30 && distance < 30) {
                        return 1;
                } else if (distance > 60 && distance < 40) {
                        return 2;
                } else {
                        return 3;
                }
        }
        
        private double getReward(int state) {
                switch(state) {
                case 0:
                        return 0.1;
                case 1:
                        return 0.25;
                case 2:
                        return 0.66;
                case 3:
                        return 1.0;
                case 4: 
                        return -1.0;
                }
                return 0.0;
        }
        
        private void updateTable(int state, int action, double update) {
                QTable[state][action] = update;
        }
        
        private double rewardFromTable(int state, int action) {
                return QTable[state][action];
        }
        


}
