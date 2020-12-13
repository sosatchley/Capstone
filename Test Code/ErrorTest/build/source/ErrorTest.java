import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ErrorTest extends PApplet {

Error err;
public void setup() {
	
	err = null;
}

public void draw() {
	background(0);
	if (err != null) {
		err.render();
	}
}

public void mouseClicked() {
	if (mouseButton == LEFT) {
		err = new Error(mouseX, mouseY, ErrorCode.AGENT_PLACEMENT);
	}
}

class Error {
    float x;
    float y;
	ErrorCode code;
    ErrorWave wave;
    ErrorContainer message;

	Error(float x, float y, ErrorCode errorCode) {
		this.x = x;
        this.y = y;
		this.code = errorCode;
        this.wave = new ErrorWave();
        this.message = new ErrorContainer();
	}

	public void render() {
		this.wave.render();
		if (mouseUnmoved()) {
			this.message.render();
		}
	}

	public boolean mouseUnmoved() {
		return (mouseX == this.x) && (mouseY == this.y);
	}

	class ErrorWave {
    	float radius;
    	boolean opening;

		ErrorWave() {
			this.radius = 1;
			this.opening = true;
        }

        public void render() {
			if (this.radius > 0) {
				fill(255,0,0,50);
				ellipse(Error.this.x, Error.this.y, this.radius, this.radius);
				if (this.opening) {
					this.radius = this.radius*2;
				} else {
					this.radius = this.radius/2;
				}
			}
			if (this.radius > .5f*width) {
				this.opening = false;
			}
    	}
	}

	class ErrorContainer {
		float containerWidth;
		float textAlpha;
        float fullContainerWidth;
        float messageX;
        float messageY;

        final float messageOffsetX;
        final float messageOffsetY;
        final float textHeight;
        final float textPadding;
		final float fullTextAlpha;

        ErrorContainer() {
            this.textHeight = 80;
            this.messageOffsetX = 20;
            this.messageOffsetY = 40;
            this.textPadding = textHeight * 0.25f;
			this.textAlpha = 0;
			this.fullTextAlpha = 255;
            textSize(this.textHeight);
            this.containerWidth = 0;
            this.fullContainerWidth = textWidth(Error.this.code.getDescription()) + (textPadding * 2);
            messageX = getMessagePosition(x, messageOffsetX, this.fullContainerWidth);
            messageY = getMessagePosition(y, messageOffsetY, this.textHeight);
        }

        public void render() {
            pushMatrix();
    		showErrorContainer();
			showErrorText(Error.this.code.getDescription());
            if (this.containerWidth > this.fullContainerWidth-this.textPadding) {
            }
    		popMatrix();
        }

    	public void showErrorContainer() {
    		stroke(255, 0, 0, this.textAlpha);
    		translate(messageX, messageY);
    		fill(0, 200);
            float containerHeight = this.textHeight + textPadding;
    		rect(0,0,this.fullContainerWidth, containerHeight, 10);
            this.containerWidth = lerp(this.containerWidth, this.fullContainerWidth, 0.1f);
    	}

    	public void showErrorText(String message) {
    		fill(255, this.textAlpha);
    		text(message, textPadding, this.textHeight);
			this.textAlpha = lerp(this.textAlpha, this.fullTextAlpha, 0.05f);
    	}

        public float getMessagePosition(float origin, float offset, float containerWidth) {
            float innerEdge = (origin + offset);
            float outerEdge = (origin + offset + containerWidth);
            float difference = (width - outerEdge);
            if (difference > 0) {
                return innerEdge;
            } else {
                return (innerEdge - (difference * -1));
            }
        }
	}
}
  public void settings() { 	size(1500, 1500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ErrorTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
