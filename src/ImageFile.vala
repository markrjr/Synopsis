namespace Synopsis{
/*
I decided to create an object to connect to icons the user 
will see on screen with the actually files that we need to archive.
Then, I can store mutiple things about the image file nicely.

*/
public class ImageFile : Object {
    
    private Gtk.Image iconImage; //This is the icon we'll show to the user. 
    private string fileType; //I think these fields are pretty self explanitory.
    private string fileName;
    private string fileLocation;
    
    public ImageFile(string fileLocation) {
        this.fileLocation = fileLocation;
        this.fileName = Path.get_basename(fileLocation);
        this.fileType = fileName.split(".")[1];
        iconImage = set_icon(fileLocation);
        print("File Name %s File Type %s \n", fileName, fileType);

    }

    public Gtk.Image set_icon(string loc)
    {
        //We have to do a bit of weirdness to actually get the icon. 
        File file = File.new_for_path(loc); //Basically, we look at the file the user has dragged in, and get the mimetype of it.
        var file_info = file.query_info("standard::content-type", 0, null);
        print ("Content type is: %s\n", file_info.get_content_type ());
        var content_type = file_info.get_content_type ();
        //Then from the mimetype we get the actual icon.
        //Example, if I drag in an mp3 file, this is going to look at that file and see it's
        //of type 'music/mp3' or something like that. It will then use that content type to retrieve the correct
        //icon which is named the same thing.
        return (new Gtk.Image.from_gicon(ContentType.get_icon(content_type), Gtk.IconSize.DIALOG)); 
    }

    public Gtk.Image get_icon()
    {
        return iconImage;
    }
}
}
