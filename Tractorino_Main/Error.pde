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

	void render() {
		// this.wave.render();
		if (mouseUnmoved()) {
			this.message.render();
		}
	}

	boolean mouseUnmoved() {
		return (mouseX == this.x) && (mouseY == this.y);
	}

	class ErrorWave {
    	float radius;
    	boolean opening;

		ErrorWave() {
			this.radius = 1;
			this.opening = true;
        }

        void render() {
			if (this.radius > 0) {
				fill(255,0,0,50);
                noStroke();
				ellipse(Error.this.x, Error.this.y, this.radius, this.radius);
				if (this.opening) {
					this.radius = this.radius*2;
				} else {
					this.radius = this.radius/2;
				}
			}
			if (this.radius > .5*width) {
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
        final PFont font;

        ErrorContainer() {
            this.textHeight = verticalResolution/90;
            this.font = createFont("LSANS", textHeight);
            this.messageOffsetX = textHeight;
            this.messageOffsetY = textHeight * 2;
            this.textPadding = textHeight * 0.25;
			this.textAlpha = 0;
			this.fullTextAlpha = 255;
            textSize(this.textHeight);
            textFont(this.font);
            this.containerWidth = 0;
            this.fullContainerWidth = textWidth(Error.this.code.getDescription()) + (textPadding * 2);
            messageX = getMessagePosition(x, messageOffsetX, this.fullContainerWidth);
            messageY = getMessagePosition(y, messageOffsetY, this.textHeight);
        }

        void render() {
            pushMatrix();
    		showErrorContainer();
			showErrorText(Error.this.code.getDescription());
            if (this.containerWidth > this.fullContainerWidth-this.textPadding) {
            }
    		popMatrix();
        }

    	void showErrorContainer() {
    		stroke(255, 0, 0, this.textAlpha);
    		translate(messageX, messageY);
    		fill(0, 200);
            float containerHeight = this.textHeight + textPadding;
    		rect(0,0,this.fullContainerWidth, containerHeight, 10);
            this.containerWidth = lerp(this.containerWidth, this.fullContainerWidth, 0.1);
    	}

    	void showErrorText(String message) {
    		fill(255, this.textAlpha);
    		text(message, textPadding, this.textHeight);
			this.textAlpha = lerp(this.textAlpha, this.fullTextAlpha, 0.05);
    	}

        float getMessagePosition(float origin, float offset, float containerWidth) {
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
