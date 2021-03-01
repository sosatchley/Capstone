public enum ObstacleMaker {
    REGION {
        // @Override
        // public Tractorino_Main.Obstacle createObstacle() {
        //     Tractorino_Main.Obstacle region = new Tractorino_Main.ObstacleRegion();
        //     return region;
        // }
        public String toString() {
          return "Region";
        }
    }, POINT {
        // @Override
        // public Tractorino_Main.Obstacle createObstacle() {
        //     Tractorino_Main.Obstacle point = new Tractorino_Main.ObstaclePoint();
        //     return point;
        // }
        public String toString() {
          return "Point";
        }
    };

    // abstract public Tractorino_Main.Obstacle createObstacle();
}
