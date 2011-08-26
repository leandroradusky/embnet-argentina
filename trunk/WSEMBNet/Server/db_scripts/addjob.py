import sqlite3
import sys
import os

def main(argv = sys.argv):
    # Add job to jobs table
    conn = sqlite3.connect("db_scripts\\db.sqlite")
    c= conn.cursor()
    
    #inserto el nuevo job 
    c.execute("""INSERT INTO jobs (jid, state, line) VALUES ('"""+argv[1]+"""',0, '"""+argv[2]+"""')""")
    conn.commit()
    
    #me fijo si hay corriendo menos de 3 cosas
    c.execute("""SELECT COUNT(*) FROM jobs WHERE state = 1""")
    
    r = c.fetchone()
    
    #si puedo correr corro
    if (r[0] != 3):
        
        c.execute("""UPDATE jobs SET state = 1 WHERE jid = '"""+argv[1]+"""'""")
        conn.commit()
        #run the line
        #os.system(argv[2])
        
    conn.close()
    

if __name__ == "__main__":
    main()