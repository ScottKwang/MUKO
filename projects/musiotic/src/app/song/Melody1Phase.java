package song;

import javafx.scene.Node;
import ui.Melody1Screen;

public class Melody1Phase extends Phase {
    private final Melody1Screen screen;

    public Melody1Phase(SongManager manager) {
        super(manager);
        screen = new Melody1Screen(this);
    }

    @Override
    public Type getType() {
        return Type.Melody1;
    }

    @Override
    public Node getScreen() {
        return screen.getScreen();
    }

    @Override
    public void addNote(String noteName, int noteLength, int notePosition) {

    }

    @Override
    public void deleteNote(String noteName, int noteLength, int notePosition) {

    }
}