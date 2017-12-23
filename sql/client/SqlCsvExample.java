import javax.xml.bind.DatatypeConverter;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.zip.GZIPInputStream;

public class SqlCsvExample {

    public static void main(String[] args) throws Exception {

        String databaseUrl = "http://10.102.0.6:8088";
        String userName = "axibase";
        String password = "********";
        String query = "SELECT * FROM \"mpstat.cpu_busy\" WHERE datetime > current_hour LIMIT 5";

        System.out.println("Execute query: " + query);

        URL url = new URL(databaseUrl + "/api/sql");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        System.out.println("Connection established to " + databaseUrl);

        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("charset", "utf-8");
        conn.setRequestProperty("Accept-Encoding", "gzip");

        String authString = userName + ":" + password;
        String authEncoded = DatatypeConverter.printBase64Binary(authString.getBytes());
        conn.setRequestProperty("Authorization", "Basic " + authEncoded);
        byte[] data = ("outputFormat=csv&q=" + query).getBytes();

        conn.setRequestProperty("Content-Length", Integer.toString(data.length));
        conn.setUseCaches(false);

        DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
        wr.write(data);

        System.out.println("Request sent");

        int code = conn.getResponseCode();

        System.out.println("Response code: " + code);

        if (code == HttpURLConnection.HTTP_OK) {
            InputStreamReader reader;
            if ("gzip".equals(conn.getContentEncoding())) {
                reader = new InputStreamReader(new GZIPInputStream(conn.getInputStream()));
            } else {
                reader = new InputStreamReader(conn.getInputStream(), "utf-8");
            }

            System.out.println();

            BufferedReader br = new BufferedReader(reader);
            String line;
            while ((line = br.readLine()) != null) {
                System.out.println(line);
            }
            br.close();

        } else {
            System.out.println(conn.getResponseMessage());
        }

    }


}
