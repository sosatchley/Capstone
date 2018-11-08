import org.apache.commons.math3.ml.neuralnet.*;
import org.apache.commons.math3.ml.neuralnet.twod.*;
import org.apache.commons.math3.ml.neuralnet.twod.util.*;
import org.apache.commons.math3.ml.neuralnet.oned.*;
import org.apache.commons.math3.ml.neuralnet.sofm.*;
import org.apache.commons.math3.ml.neuralnet.sofm.util.*;
import org.apache.commons.math3.ml.clustering.*;
import org.apache.commons.math3.ml.clustering.evaluation.*;
import org.apache.commons.math3.ml.distance.*;
import org.apache.commons.math3.analysis.*;
import org.apache.commons.math3.analysis.differentiation.*;
import org.apache.commons.math3.analysis.integration.*;
import org.apache.commons.math3.analysis.integration.gauss.*;
import org.apache.commons.math3.analysis.function.*;
import org.apache.commons.math3.analysis.polynomials.*;
import org.apache.commons.math3.analysis.solvers.*;
import org.apache.commons.math3.analysis.interpolation.*;
import org.apache.commons.math3.stat.interval.*;
import org.apache.commons.math3.stat.ranking.*;
import org.apache.commons.math3.stat.clustering.*;
import org.apache.commons.math3.stat.*;
import org.apache.commons.math3.stat.inference.*;
import org.apache.commons.math3.stat.correlation.*;
import org.apache.commons.math3.stat.descriptive.*;
import org.apache.commons.math3.stat.descriptive.rank.*;
import org.apache.commons.math3.stat.descriptive.summary.*;
import org.apache.commons.math3.stat.descriptive.moment.*;
import org.apache.commons.math3.stat.regression.*;
import org.apache.commons.math3.linear.*;
import org.apache.commons.math3.*;
import org.apache.commons.math3.distribution.*;
import org.apache.commons.math3.distribution.fitting.*;
import org.apache.commons.math3.complex.*;
import org.apache.commons.math3.ode.*;
import org.apache.commons.math3.ode.nonstiff.*;
import org.apache.commons.math3.ode.events.*;
import org.apache.commons.math3.ode.sampling.*;
import org.apache.commons.math3.random.*;
import org.apache.commons.math3.primes.*;
import org.apache.commons.math3.optim.*;
import org.apache.commons.math3.optim.linear.*;
import org.apache.commons.math3.optim.nonlinear.vector.*;
import org.apache.commons.math3.optim.nonlinear.vector.jacobian.*;
import org.apache.commons.math3.optim.nonlinear.scalar.*;
import org.apache.commons.math3.optim.nonlinear.scalar.gradient.*;
import org.apache.commons.math3.optim.nonlinear.scalar.noderiv.*;
import org.apache.commons.math3.optim.univariate.*;
import org.apache.commons.math3.exception.*;
import org.apache.commons.math3.exception.util.*;
import org.apache.commons.math3.fitting.leastsquares.*;
import org.apache.commons.math3.fitting.*;
import org.apache.commons.math3.dfp.*;
import org.apache.commons.math3.fraction.*;
import org.apache.commons.math3.special.*;
import org.apache.commons.math3.geometry.*;
import org.apache.commons.math3.geometry.hull.*;
import org.apache.commons.math3.geometry.enclosing.*;
import org.apache.commons.math3.geometry.spherical.twod.*;
import org.apache.commons.math3.geometry.spherical.oned.*;
import org.apache.commons.math3.geometry.euclidean.threed.*;
import org.apache.commons.math3.geometry.euclidean.twod.*;
import org.apache.commons.math3.geometry.euclidean.twod.hull.*;
import org.apache.commons.math3.geometry.euclidean.oned.*;
import org.apache.commons.math3.geometry.partitioning.*;
import org.apache.commons.math3.geometry.partitioning.utilities.*;
import org.apache.commons.math3.optimization.*;
import org.apache.commons.math3.optimization.linear.*;
import org.apache.commons.math3.optimization.direct.*;
import org.apache.commons.math3.optimization.fitting.*;
import org.apache.commons.math3.optimization.univariate.*;
import org.apache.commons.math3.optimization.general.*;
import org.apache.commons.math3.util.*;
import org.apache.commons.math3.genetics.*;
import org.apache.commons.math3.transform.*;
import org.apache.commons.math3.filter.*;

class Field {
    Boolean drawing;
    Boolean begun;
    PShape shape;
    PShape start;
    float startx;
    float starty;
    int v;
    Agent agent;


    Field(Agent agent) {
        this.agent = agent;
        this.v = 0;
        this.begun = false;
    }

    void startField() {
        this.startx = this.agent.getAxle().pos.x;
        this.starty = this.agent.getAxle().pos.y;
        stroke(255, 0, 0);
        noFill();
        this.start = createShape(RECT, this.startx-15,this.starty-15, 30, 30);
        this.shape = createShape();
        this.shape.beginShape();
        this.shape.stroke(112, 143, 250);
        this.drawing = true;
        this.begun = true;
    }

    void render() {
        if (this.drawing) {
            shape(this.start);
            float x = this.agent.getAxle().pos.x;
            float y = this.agent.getAxle().pos.y;
            updateShape(x, y);
        }
        if (this.shape != null) {
            shape(this.shape);
        }
    }

    void updateShape(float x, float y) {
        if (!complete(x, y)) {
            this.shape.vertex(x, y);
            this.v++;
            println(this.v);
            point(x,y);
        }
    }

    Boolean complete(float x, float y) {
        if (this.v < 200) {
            return false;
        }
        if (( x > this.startx-15 && x < this.startx + 15) && (y > this.starty-15 && y < this.starty + 15)) {
            this.drawing = false;
            this.shape.fill(87, 43, 163);
            this.shape.endShape(CLOSE);
            this.v = 0;
            // this.start.setVisable(false);
            return true;
        }
        return false;
    }
}
