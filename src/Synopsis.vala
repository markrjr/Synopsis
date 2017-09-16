/* Copyright 2014 Mark Raymond Jr.
*
* This file is part of Synopsis
*
* Synopsis is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* Synopsis is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with Synopsis. If not, see http://www.gnu.org/licenses/.
*/ 

using Gtk;
using Gee;
using Granite;
using Granite.Services;

namespace Synopsis {
public class MainWindow : Gtk.Window
{
    private Gtk.Image dropIcon;
    private Gtk.Label dropLabel;
    private Gtk.Box container;
    private bool fileExistsInWindow = false; //Assuming this is the first time we've opened the app, nobody has dragged anything into the window yet.
    public ArrayList<ImageFile> filesList; //See below in main.



    public MainWindow ()
    {
        this.title = "Synopsis";
        this.window_position = WindowPosition.CENTER;
        this.destroy.connect (Gtk.main_quit);
        set_default_size (640, 480);   
        
        container = new Box (Orientation.VERTICAL, 6);
        container.margin = 6;
        container.set_homogeneous(false);
        add (container);

        //Setup the drop icon image. Add a try catch block here later.
        dropIcon = new Gtk.Image();
        try{
            dropIcon.set_from_file("/usr/share/Synopsis/uncompressed.png");
        } catch(Error e) {
            stderr.printf ("Could not load application icon: %s\n", e.message);
        }


        container.add(dropIcon);
        container.set_child_packing(dropIcon, false, false, 100, Gtk.PackType.START);

        //A little label for peoples.
        dropLabel = new Gtk.Label("Drag your file(s) above.");
        container.add(dropLabel);
        

        //Connect drag drop handlers
        Gtk.drag_dest_set (this,Gtk.DestDefaults.ALL, targets, Gdk.DragAction.COPY);
        this.drag_data_received.connect(this.on_drag_data_received);
    }

    private void on_drag_data_received (Gdk.DragContext drag_context, int x, int y, 
                                        Gtk.SelectionData data, uint info, uint time) 
    {
        //loop through list of URIs
        foreach(string uri in data.get_uris ()){
            string file = uri.replace("file://","").replace("file:/","");
            file = Uri.unescape_string (file);

            //add file to tree view
            add_file (file);
        }

        Gtk.drag_finish (drag_context, true, false, time);
        

    }
      
    private void add_file(string file)
    {
        /*When the user drags in a file, we need to check if this is the first file
        that's been dragged into the app. If it is, setup the UI for the container view window.
        If it isn't, just add an icon of the file in the View Window.*/
        if(fileExistsInWindow)
        {

            print("Already here." + file + "\n"); 
            filesList.add(new ImageFile(file)); //Add a new ImageFile to our list.
            var last = filesList.get(filesList.size - 1);  //Get that anonymous object we just added to the arraylist above.
            container.add(last.get_icon());
            show_all();
        }
        else
        {
            container.remove(dropIcon);
            dropLabel.set_text("Drop your file(s) below.");
            fileExistsInWindow = true;
            print("First time " + file + "\n");
            filesList.add(new ImageFile(file)); //Add a new ImageFile to our list.
            var last = filesList.get(filesList.size - 1);  //Get that anonymous object we just added to the arraylist above.
            container.add(last.get_icon());
            show_all();
        }
    }

    private const Gtk.TargetEntry[] targets = {
        {"text/uri-list",0,0}
    };
    
}


public class Synopsis : Granite.Application
{

    public MainWindow app;


    construct {
       	 program_name = "Synopsis"; //the name of your program
       	 exec_name = "Synopsis";	//the name of the executable, usually the name in lower case
       	 
       	 /*
       	 //those will be defined in a separate constants file, don't care about them here
       	 build_data_dir = Constants.DATADIR;
       	 build_pkg_data_dir = Constants.PKGDATADIR;
       	 build_release_name = Constants.RELEASE_NAME;
       	 build_version = Constants.VERSION;
       	 build_version_info = Constants.VERSION_INFO;
       	 */
       	 
       	 app_years = "2014";
       	 app_icon = "drop";
         app_icon = "synopsis"; 
       	 app_launcher = "Synopsis.desktop"; 
       	 application_id = "org.elementary.Synopsis";  //an unique id which will identify your application
       	 
       	 //those urls will be shown in the automatically generated about dialog
       	 main_url = "https://code.launchpad.net/~markrtoon/synopsis/trunk";

       	 
       	 about_authors = {"Mark Raymond Jr. <markrjr@live.com>"};
       	 about_documenters = {"Mark Raymond Jr. <markrjr@live.com>"};
       	 about_artists = {"Daniel Fore"};  
       	 //about_comments = ("A simple and concise archive utility.");  
       	 about_license_type = License.GPL_3_0;
    }
        
    public Synopsis() {
        this.set_flags (ApplicationFlags.HANDLES_OPEN);
        
    }

    public override void activate () {
    if (this.app == null)
   	 	build_and_run ();
    }
    

    public void build_and_run () {
        this.app = new MainWindow();
        app.show_all();

    }
    


    public static int main (string[] args) 
    {
        Gtk.init(ref args); 

        var window = new MainWindow (); 
        //Setup icon.
        try {
            // Either directly from a file ...
            window.icon = new Gdk.Pixbuf.from_file ("/usr/share/Synopsis/drop.png");
            // ... or from the theme
            //window.icon = IconTheme.get_default ().load_icon ("synopsis", 48, 0);
        } catch (Error e) {
            stderr.printf ("Could not load application icon: %s\n", e.message);
        }
        //Initialize the the ArrayList that will hold our image files.
        window.filesList = new ArrayList<ImageFile>();

        //Dialog will enable later window.set_type_hint(Gdk.WindowTypeHint.DIALOG);
        //window.set_icon(icon);
        Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
        window.show_all (); 

        Gtk.main();

        return 0;
    }

}
}
