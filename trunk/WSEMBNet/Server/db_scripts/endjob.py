import sqlite3
import sys
import os

def main(argv = sys.argv):
    # Add job to jobs table
    conn = sqlite3.connect("db.sqlite")
    c= conn.cursor()
    
    #end the job 
    c.execute("""UPDATE jobs SET state = 2 WHERE jid = '"""+argv[1]+"""'""")
    conn.commit()
    
    #launch new job id
    c.execute("""SELECT COUNT(*) FROM jobs WHERE state = 1""")
    r = c.fetchone()
    
    while (r[0] < 3):
        
        c.execute("""SELECT jid, line FROM jobs WHERE state = 0""")
        r = c.fetchone()

        if (r != None):
            c.execute("""UPDATE jobs SET state = 1 WHERE jid = '"""+r[0]+"""'""")
            conn.commit()
            #run the line
            #os.system(r[1])
            
            # if i can run more, do it
            c.execute("""SELECT COUNT(*) FROM jobs WHERE state = 1""")
            r = c.fetchone()
        else:
            break        
        
    conn.close()
    

if __name__ == "__main__":
    main()