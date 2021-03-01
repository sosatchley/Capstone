public enum CutterMaker {
    ROTARYCUTTER {
        @Override
        public Agent.Cutter createCutter() {
            Agent.Cutter rotaryCutter = this.agent.new RotaryCutter();
            return rotaryCutter;
        }
        // public Agent.Cutter createCutter(PVector pos, float angle) {
        //     Agent.Cutter; rotaryCutter = this.agent.new RotaryCutter(PVector pos, float angle);
        //     return rotaryCutter;
        // }
        // public String toString() {
        //   return "Brush Hog";
        // }
    }, DISCMOWER {
        @Override
        public Agent.Cutter createCutter() {
            Agent.Cutter discMower = this.agent.new DiscMower();
            return discMower;
        }
        // @Override
        // public Agent.Cutter createCutter(PVector pos, float angle) {
        //     Agent.Cutter discMower = this.agent.new DiscMower(PVector pos, float angle);
        //     return discMower;
        // }
        // public String toString() {
        //   return "Hay Cutter";
        // }
    };
    public Agent agent;

    abstract public Agent.Cutter createCutter();

    // abstract public Agent.Cutter createCutter(PVector pos, float angle);

    public void setEnclosingInstance(Agent enclosingInstance) {
        this.agent = enclosingInstance;
    }
}
