import St from 'gi://St';
import Gio from 'gi://Gio';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

export default class PanelSpacingExtension extends Extension {
    enable() {
        this._settings = this.getSettings();
        this._applySpacing();
        this._changedId = this._settings.connect('changed::icon-spacing', () => this._applySpacing());
    }

    disable() {
        if (this._changedId) {
            this._settings.disconnect(this._changedId);
            this._changedId = null;
        }
        this._unloadStylesheet();
        this._settings = null;
    }

    _applySpacing() {
        const spacing = this._settings.get_int('icon-spacing');
        const css = `#panel .panel-button .panel-status-indicators-box { spacing: ${spacing}px; }\n`;
        const cssPath = `${this.path}/generated.css`;

        const file = Gio.File.new_for_path(cssPath);
        file.replace_contents(
            new TextEncoder().encode(css),
            null, false,
            Gio.FileCreateFlags.REPLACE_DESTINATION,
            null
        );

        this._unloadStylesheet();
        this._stylesheet = Gio.File.new_for_path(cssPath);
        St.ThemeContext.get_for_stage(global.stage).get_theme().load_stylesheet(this._stylesheet);
    }

    _unloadStylesheet() {
        if (this._stylesheet) {
            St.ThemeContext.get_for_stage(global.stage).get_theme().unload_stylesheet(this._stylesheet);
            this._stylesheet = null;
        }
    }
}
