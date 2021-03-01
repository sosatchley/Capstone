package robosim.ai;

import robosim.core.Action;
import robosim.core.Simulator;
import java.util.concurrent.ThreadLocalRandom;

public class IntLearner implements Controller {

        double[][] QTable;
        int[][] visits;
        double gamma = 0.025;
        int count = 0;

        @Override
        public void control(Simulator sim) {
                if (count < 1) {
                        initializeTable();
                }
                count++;
                double distance = sim.findClosest();
                int state = getState(distance, sim);
                for (double alpha = 1.0; alpha > 0.0; alpha-=0.5) {
                        double reward = getReward(state);
                        int action = pickAction(state, count);
                        int statePrime = applyAction(action, sim);
                        double update = (1-alpha) * rewardFromTable(state, action) + alpha*(reward + gamma * pickMaxAction(statePrime));
                        updateTable(state, action, update);
                        System.out.println("Count: " + count);
                        for (int j = 0; j < QTable.length; j++) {
                                for (int i = 0; i < QTable[j].length; i++) {
                                        System.out.print("[" + visits[j][i] + "]");
                                }
                                System.out.println("");
                        }
                        System.out.println("---------");
                        state = statePrime;
                }
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

        private int pickAction(int state, int count) {
                if (state == 4) {
                        return 1;
                }
//                if (count < 1000) {
                        return explore(state);
//                } else if (count > 1000) {
//                        exploit(state);
//                }

//                double best = 0.0;
//                int index = 0;
//                while (visits[state][index] > sumVisits(state, index)/3)
//                for (int i = 0; i < QTable[state].length; i++) {
//                        if (QTable[state][i] > best) {
//                                if ((visits[state][i] / sumVisits(state, -1) > 0.5)) {
//                                if (!(visits[state][i] > (sumVisits(state, -1)/4 + 20))) {
//                                        best = QTable[state][i];
//                                        index = i;
//                                }
//                        }
//                }



//                visits[state][index] += 1;
//                return index;
        }

        private int exploit(int state) {
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

        private int explore(int state) {
                if (state != 4) {
//                        int sum = 0;
                        for (int i = 0; i < 4; i++) {

                        }
//                        int lowest = Integer.MAX_VALUE;
//                        int index = 0;
//                        for (int i = 0; i < visits[state].length; i++) {
//                                if (visits[state][i] < lowest) {
//                                        lowest = visits[state][i];
//                                        index = i;
//                                }
//                        }
//                        if (lowest > 250) {
//                                index = 0;
//                        }
                        int index = ThreadLocalRandom.current().nextInt(0, 3 + 1);
                        if (sumVisits(state, -1) > 1000) {
                                index = 0;
                        }
                        visits[state][index] += 1;
                        return index;
                } else {
                        return exploit(state);
                }

        }

        private int sumVisits(int stateIndex, int actionIndex) {
                int sum = 0;
                for (int i = 0; i < visits[stateIndex].length; i++) {
                        if (actionIndex < 0) {
                                sum += visits[stateIndex][i];
                        } else if (i != actionIndex) {
                                sum += visits[stateIndex][i];
                        }
                }
                return sum;
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
                return index;

        }

        private int getState(double distance, Simulator sim) {
                if (sim.wasHit() || sim.findClosest() < 10) {
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
                        return 0.7;
                case 1:
                        return 0.8;
                case 2:
                        return 0.9;
                case 3:
                        return 1.0;
                case 4:
                        return 0.0;
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
