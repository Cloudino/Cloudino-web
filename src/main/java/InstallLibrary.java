
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author javiersolis
 */
public class InstallLibrary {
    public static void main(String[] args) throws IOException
    {
        String file="https://github.com/arduino-libraries/Audio/archive/1.0.0.zip";
        String name="Audio";
        String userpath="/programming/proys/cloudino/server/Cloudino-web/target/Cloudino-web-1.0-SNAPSHOT/work/cloudino/users/55e0d655e4b0cb620e1910e5";
        
        URLConnection con=new URL(file).openConnection();
        ZipInputStream zip=new ZipInputStream((InputStream)con.getContent());
        
        String libpath=userpath+"/arduino/libraries/";
        
        File rootDir=null;
        int BUFFER = 2048;
        ZipEntry entry=null;
        while((entry=zip.getNextEntry())!=null)
        {
            if(entry.isDirectory())
            {
                System.out.println("dir:"+entry.getName());
                File dir=new File(libpath+entry.getName());
                dir.mkdirs();
                if(rootDir==null)rootDir=dir;                
            }else
            {
                if(rootDir==null)break;
                System.out.println("file:"+entry.getName());
                FileOutputStream fout=new FileOutputStream(libpath+entry.getName());
                BufferedOutputStream dest = new BufferedOutputStream(fout, BUFFER);
                byte data[] = new byte[BUFFER];
                int count=0;                
                while ((count = zip.read(data, 0, BUFFER)) != -1) {
                    dest.write(data, 0, count);
                }
                dest.flush();
                dest.close();
            }
        }
        if(rootDir!=null)rootDir.renameTo(new File(rootDir.getParent(),name));
    }
}
