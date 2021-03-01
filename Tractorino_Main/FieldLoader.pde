// import org.json.simple.JSONArray;
// import org.json.simple.JSONObject;
// import org.json.simple.parser.JSONParser;
import java.io.FileWriter;
import java.io.IOException;

public class FieldLoader {

    // FieldLoader() {}

    public void createSessionFile() {
        JSONObject sessionJson = new JSONObject();
        sessionJson.setJSONObject("field", writeFieldJson());
        sessionJson.setJSONObject("agent", writeAgentJson());
        exportJsonFile(sessionJson);
    }

    private JSONObject writeFieldJson() {
        JSONObject fieldObject = new JSONObject();
        fieldObject.setJSONArray("shape", shapeToJson(field));
        fieldObject.setJSONArray("obstacles", writeObstaclesJson());
        return fieldObject;
    }

    private JSONArray writeObstaclesJson() {
        JSONArray obstaclesArray = new JSONArray();
        for (Obstacle obs : field.obstacles) {
            obstaclesArray.append(shapeToJson((DrawnRegion) obs));
        }
        return obstaclesArray;
    }

    private JSONObject writeAgentJson() {
        JSONObject agentObject = new JSONObject();
        agentObject.setJSONObject("wheels", writeWheelsJson());
        agentObject.setJSONObject("machine", writeMachineJson());
        agentObject.setJSONObject("cutter", writeCutterJson());
        return agentObject;
    }

    private JSONObject writeWheelsJson() {
        JSONObject wheelsObject = new JSONObject();
        wheelsObject.setJSONObject("pos", vectorToJson(agent.wheels.getPosition()));
        wheelsObject.setFloat("angle", agent.wheels.getAngle());
        return wheelsObject;
    }

    private JSONObject writeMachineJson() {
        JSONObject machineObject = new JSONObject();
        machineObject.setJSONObject("pos", vectorToJson(agent.machine.getPosition()));
        machineObject.setFloat("angle", agent.machine.getAngle());
        return machineObject;
    }

    private JSONObject writeCutterJson() {
        JSONObject cutterObject = new JSONObject();
        cutterObject.setJSONObject("pos", vectorToJson(agent.cutter.getPosition()));
        cutterObject.setFloat("angle", agent.cutter.getAngle());
        cutterObject.setString("type", agent.cutter.getType());
        return cutterObject;
    }

    private JSONArray shapeToJson(DrawnRegion region) {
        return vertexArrayToJson(region.getShapeVertices());
    }

    private JSONArray vertexArrayToJson(float[][] verts) {
        JSONArray verticies = new JSONArray();
        for (int i = 0; i < verts.length; i++) {
            verticies.append(vertexToJson(verts[i][0], verts[i][1]));
        }
        return verticies;
    }

    private JSONObject vectorToJson(PVector vector) {
        return vertexToJson(vector.x, vector.y);
    }

    private JSONObject vertexToJson(float x, float y) {
        JSONObject vert = new JSONObject();
        vert.setFloat("x", x);
        vert.setFloat("y", y);
        return vert;
    }

    private void exportJsonFile(JSONObject object) {
        String saveFolder = "Fields Exports\\";
        String name = String.valueOf(System.currentTimeMillis());
        String fileExtension = ".json";
        String fullFileName = saveFolder + name + fileExtension;
        String filePath = savePath(fullFileName);
        FileWriter file = null;
        try {

            // Strings
            file = new FileWriter(filePath);
            file.write(object.toString());

            //Bytes
            // OutputStream out = createOutput(fullFileName);
            // byte[] data = object.toJSONString().getBytes();
            // saveBytes(out, data);
        } catch (IOException e) {
            e.printStackTrace();

        } finally {
            try {
                file.flush();
                file.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void loadSessionFile() {
        selectInput("Select a field to load", "parseSessionJson", saveFile("test.json"), this);
    }

    public void parseSessionJson(File file) {
        if (file == null) {
            return;
        }
        JSONObject json = loadJSONObject(file);
        field = loadFieldFromJson((JSONObject) json.get("field"));
        agent = loadAgentFromJson((JSONObject) json.get("agent"));
    }

    private Agent loadAgentFromJson(JSONObject agentObject) {
        Agent bareAgent = new Agent();
        loadWheelsFromJson((JSONObject) agentObject.get("wheels"), bareAgent);
        loadMachineFromJson((JSONObject) agentObject.get("machine"), bareAgent);
        loadCutterFromJson((JSONObject) agentObject.get("cutter"), bareAgent);
        return bareAgent;
    }

    private void loadWheelsFromJson(JSONObject wheelsObject, Agent enclosing) {
        PVector pos = parseVertexObject((JSONObject) wheelsObject.get("pos"));
        float angle = wheelsObject.getFloat("angle");
        enclosing.setWheels(pos, angle);
    }

    private void loadMachineFromJson(JSONObject machineObject, Agent enclosing) {
        PVector pos = parseVertexObject((JSONObject) machineObject.get("pos"));
        float angle = machineObject.getFloat("angle");
        enclosing.setMachine(pos, angle);
    }

    private void loadCutterFromJson(JSONObject cutterObject, Agent enclosing) {
        PVector pos = parseVertexObject((JSONObject) cutterObject.get("pos"));
        float angle = cutterObject.getFloat("angle");
        enclosing.setCutter(CutterMaker.valueOf(cutterObject.getString("type")));
        enclosing.cutter.setPosition(pos);
        enclosing.cutter.setAngle(angle);
        // return tool.createCutter(pos, angle);
    }

    private Field loadFieldFromJson(JSONObject fieldObject) {
        PShape fieldShape = parseVertexArrayAsShape((JSONArray) fieldObject.get("shape"));
        List<Obstacle> obstacles = loadObstaclesFromJson((JSONArray) fieldObject.get("obstacles"));
        return new Field(fieldShape, obstacles);
    }

    private List<Obstacle> loadObstaclesFromJson(JSONArray obstacleArray) {
        List<Obstacle> obstacles = new ArrayList<Obstacle>();
        for (int i = 0; i < obstacleArray.size(); i++) {
            Obstacle obs = buildObstacleFromArray((JSONArray) obstacleArray.get(i));
            obstacles.add(obs);
        }
        return obstacles;
    }

    private Obstacle buildObstacleFromArray(JSONArray array) {
        PShape shape = parseVertexArrayAsShape(array);
        if (shape.getVertexCount() > 1) {
            return new ObstacleRegion(shape);
        } else {
            return new ObstaclePoint(shape);
        }
    }

    private PShape parseVertexArrayAsShape(JSONArray verts) {
        PShape shape = createShape();
        shape.beginShape();
        for (int i = 0; i < verts.size(); i++) {
            PVector vertex = parseVertexObject((JSONObject) verts.get(i));
            shape.vertex(vertex.x, vertex.y);
        }
        shape.endShape(CLOSE);
        return shape;
    }

    public PVector parseVertexObject(JSONObject vertex) {
        float x = vertex.getFloat("x");
        float y = vertex.getFloat("y");
        return new PVector(x, y);
    }
}
