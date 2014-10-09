all:
	make -C map-api
	make -C sql-api
	make -C rails-app

clean:
	make -C sql-api clean
	make -C map-api clean
	#make -C rails-app clean

check:
	make -C sql-api check
	make -C map-api check
	make -C rails-app check
