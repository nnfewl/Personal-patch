import Adw from 'gi://Adw';
import {ExtensionPreferences} from 'resource:///org/gnome/Shell/Extensions/js/extensions/prefs.js';

export default class PanelSpacingPreferences extends ExtensionPreferences {
    fillPreferencesWindow(window) {
        const settings = this.getSettings();

        const page = new Adw.PreferencesPage({
            title: 'Panel Spacing',
            icon_name: 'preferences-system-symbolic',
        });

        const group = new Adw.PreferencesGroup({
            title: 'System Tray',
            description: 'Spacing between icons in the Quick Settings button (WiFi, volume, battery)',
        });

        const spin = Adw.SpinRow.new_with_range(0, 48, 1);
        spin.title = 'Icon Spacing';
        spin.subtitle = 'Pixels between tray icons';
        spin.set_value(settings.get_int('icon-spacing'));

        spin.connect('output', widget => {
            settings.set_int('icon-spacing', parseInt(widget.get_value(), 10));
            return false;
        });

        group.add(spin);
        page.add(group);
        window.add(page);
    }
}
