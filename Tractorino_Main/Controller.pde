class Controller {
    Agent agent;
    float[][] QTable;
    int[][] visits;
    float gamma = 0.5;
    float alpha = 0.5;
    int count = 0;

    Controller(Agent agent) {
        this.agent = agent;
    }

    void control() {
        if (count < 1) {
            initializeTable();
        }
        count++;
        float distClosest = this.agent.dist;
        float angleClosest = this.agent.closestVertex.angle;
        float cutterAngle = degrees(this.agent.cutterAngle);

        int state = getState(distClosest, angleClosest, cutterAngle);
        float reward = getReward(state);
        int action;
        if (this.count < 10000) {
            action = pickAction(state);
        } else {
            action = pickMaxAction(state);
        }
        int statePrime = applyAction(action);
        float update = (1-alpha) * rewardFromTable(state, action) +
                    alpha*(reward + gamma * pickMaxAction(statePrime));
        updateTable(state, action, update);
        // for (int j = 0; j < QTable.length; j++) {
        //     for (int i = 0; i < QTable[j].length; i++) {
        //         System.out.print("[" + visits[j][i] + "]");
        //     }
        //     System.out.println("");
        // }
        // System.out.println("---------");
        state = statePrime;
    }

    void initializeTable() {
        QTable = new float[8][3];
        visits = new int[8][3];
        for (int i = 0; i < QTable.length; i++) {
                for (int j = 0; j < QTable[i].length; j++) {
                        float r = random(0, 1);
                        QTable[i][j] = 0;
                        visits[i][j] = 0;
                }
        }
    }

    int getState(float distance, float vertAngle, float cutterAngle) {
        if (cutterIsGood(cutterAngle)) {
            if (distIsGood(distance)) {
                if (steeringLess(vertAngle)) {
                    return 0;
                } else {
                    return 1;
                }
            } else {
                if (steeringLess(vertAngle)) {
                    return 2;
                } else {
                    return 3;
                }
            }
        } else {
            if (distIsGood(distance)) {
                if (steeringLess(vertAngle)) {
                    return 4;
                } else {
                    return 5;
                }
            } else {
                if (steeringLess(vertAngle)) {
                    return 6;
                } else {
                    return 7;
                }
            }
        }
    }

    float getReward(int state) {
        switch(state) {
        case 0:
                return 1.0;
        case 1:
                return 1.0;
        case 2:
                return 0.5;
        case 3:
                return 0.5;
        case 4:
                return -0.2;
        case 5:
                return -0.2;
        case 6:
                return -10.0;
        case 7:
                return -10.0;
        }
        return 0.0;
    }

    int pickAction(int state) {
        double best = 0.0;
        int index = 0;
        float r = random(3);
        int f = floor(r);
        // for (int i = 0; i < QTable[state].length; i++) {
        //         if (QTable[state][i] == 0.0) {
        //                 index = i;
        //         } else if (QTable[state][i] > best){
        //             best = QTable[state][i];
        //             index = i;
        //         }
        // }
        visits[state][index] += 1;
        return f;
    }

    int pickMaxAction(int state) {
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

    int applyAction(int index) {
        switch(index) {
        case 0:
                this.agent.turn(1);
                // println("Went right");
                break;
        case 1:
                this.agent.turn(0);
                // println("Went left");
                break;
        case 2:
                this.agent.turn(2);
                // println("Went straight");
                break;
        }
        float distClosest = this.agent.dist;
        float angleClosest = this.agent.closestVertex.angle;
        float cutterAngle = this.agent.cutterAngle;
        return getState(distClosest, angleClosest, cutterAngle);
    }

    void updateTable(int state, int action, float update) {
        QTable[state][action] = update;
    }

    float rewardFromTable(int state, int action) {
        return QTable[state][action];
    }

    boolean distIsGood(float dist) {
        System.out.println(dist);
        return dist < 10 ? true : false;
    }

    boolean cutterIsGood(float angle) {
        return angle < 50 ? true : false;
    }

    boolean steeringLess(float angle) {
        return abs(angle) > abs(this.agent.wheels.steeringAngle) ? true : false;
    }

    void printQ() {
        for (int j = 0; j < QTable.length; j++) {
            for (int i = 0; i < QTable[j].length; i++) {
                System.out.print("[" + QTable[j][i] + "]");
            }
            System.out.println("");
        }
        System.out.println("---------");
    }
}
