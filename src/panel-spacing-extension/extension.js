import St from 'gi://St';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

export default class PanelSpacingExtension extends Extension {
    enable() {
        this._stylesheet = this.dir.get_child('stylesheet.css');
        St.ThemeContext.get_for_stage(global.stage).get_theme().load_stylesheet(this._stylesheet);
    }

    disable() {
        St.ThemeContext.get_for_stage(global.stage).get_theme().unload_stylesheet(this._stylesheet);
    }
}
