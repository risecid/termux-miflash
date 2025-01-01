#!/bin/bash
lightcyan='\e[96m'
Reset="${Escape}[0m";
Escape="\033";
red='\e[1;31m'
ver="1.2"
function banner1 (){
echo """
  ┈┈┈╲┈┈┈┈╱			 
  ┈┈┈╱▔▔▔▔╲      ██████╗░██╗██████╗░██╗░░░██╗███╗░░██╗██╗░░██╗
  ┈┈┃┈▇┈┈▇┈┃     ██╔══██╗██║██╔══██╗██║░░░██║████╗░██║██║░██╔╝
  ╭╮┣━━━━━━┫╭╮   ██████╔╝██║██████╔╝██║░░░██║██╔██╗██║█████═╝░
  ┃┃┃┈┈┈┈┈┈┃┃┃   ██╔══██╗██║██╔═══╝░██║░░░██║██║╚████║██╔═██╗░
  ╰╯┃┈┈┈┈┈┈┃╰╯   ██║░░██║██║██║░░░░░╚██████╔╝██║░╚███║██║░╚██╗
  ┈┈╰┓┏━━┓┏╯     ╚═╝░░╚═╝╚═╝╚═╝░░░░░░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝
  ┈┈┈╰╯┈┈╰╯				version : $ver
******************************************************************
*  Peringatan: Flashing perangkat akan menghapus semua data!     *
*  Pastikan Anda telah membuat cadangan data Anda.               *
*  Dan Saya Tidak BerTanggung Jawab Jika Terjadi Apa-apa         *
*  terhadap Hp Kalian, Resiko Di tanggung Penumpang :)           *
******************************************************************"""
}

ctrl_c() {
clear
echo -e $red"[*] (Ctrl + C )... "
exit
}
# Fungsi untuk menampilkan pesan kesalahan
show_error() {
  dialog --title "Error" --msgbox "$1" 10 40
}

# Fungsi untuk memilih berkas TWRP
select_twrp() {
  twrp_file=$(dialog --title "Pilih Berkas TWRP" --stdout --fselect /sdcard/ 14 60)
}

# Fungsi untuk flashing TWRP menggunakan Fastboot
flash_twrp() {
  fastboot flash recovery $twrp_file
}

# Fungsi untuk memilih berkas rom
select_rom() {
  rom_file=$(dialog --title "Pilih Berkas Rom" --stdout --fselect /sdcard/ 14 60)
}

# Fungsi untuk flashing rom menggunakan Fastboot
flash_rom() {
  clear
  banner1 | lolcat
  echo ""
  echo "===========================================================" | lolcat
  find ${rom_file}*.sh > ${rom_file}a.txt 2>&1
  cat ${rom_file}a.txt | grep -e "flash_" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
  sed -i 's/.sh//g' ${rom_file}a.txt 2>&1
  sed -i 's/fl/flash/g' ${rom_file}a.txt > /dev/null 2>&1
  cat ${rom_file}a.txt | lolcat
  echo "===========================================================" | lolcat
  rm -r ${rom_file}a.txt > /dev/null 2>&1
  read -p "ketik disini : " flash
  sleep 2
  clear
  banner1 | lolcat
  echo "Masuk Mode Fastboot Kemudian Sambungkan" | lolcat
  bash $flash.sh | lolcat
  else
  rm -r ${rom_file}a.txt > /dev/null 2>&1
  echo "Folder Rom Tidak Di Temukan" | lolcat
  echo "===========================================================" | lolcat
  sleep 10
  banner | lolcat
  
  fi
}


# Fungsi untuk memilih berkas romedl
edl_rom() {
  edl_firehose_file=$(dialog --title "Pilih Berkas prog_emmc_firehose_xxxx_xxx.mbn" --stdout --fselect /path/to/rom/prog_emmc_firehose_xxxx_xxx.mbn 14 60)
}

# Fungsi untuk memilih berkas folderedl
edl_rom1() {
  edl_firehose_folder=$(dialog --title "Pilih Folder Rom" --stdout --fselect /path/to/rom/ 14 60)
}

# Fungsi untuk flashing rom menggunakan Fastboot
flash_rom_edl() {
  qdl --debug --storage emmc --include $edl_firehose_folder $edl_firehose_file $edl_firehose_folder/rawprogram0.xml $edl_firehose_folder/patch0.xml
}
# Main menu using dialog
while true; do
    clear
    # Menampilkan pesan sebelum flash
function banner (){
echo """
┈┈┈╲┈┈┈┈╱			 
┈┈┈╱▔▔▔▔╲      ██████╗░██╗██████╗░██╗░░░██╗███╗░░██╗██╗░░██╗
┈┈┃┈▇┈┈▇┈┃     ██╔══██╗██║██╔══██╗██║░░░██║████╗░██║██║░██╔╝
╭╮┣━━━━━━┫╭╮   ██████╔╝██║██████╔╝██║░░░██║██╔██╗██║█████═╝░
┃┃┃┈┈┈┈┈┈┃┃┃   ██╔══██╗██║██╔═══╝░██║░░░██║██║╚████║██╔═██╗░
╰╯┃┈┈┈┈┈┈┃╰╯   ██║░░██║██║██║░░░░░╚██████╔╝██║░╚███║██║░╚██╗
┈┈╰┓┏━━┓┏╯     ╚═╝░░╚═╝╚═╝╚═╝░░░░░░╚═════╝░╚═╝░░╚══╝╚═╝░░╚═╝
┈┈┈╰╯┈┈╰╯				version : $ver

  ******************************************************
  *        	TERMUX Android ROM Flasher          *
  ******************************************************

			1 Flash TWRP
			2 Flash Rom Fastboot
			3 Flash Rom EDL Mode
			4 Bypass Account Mi
			5 Bypass Frp
			6 Exit""" 
}
banner | lolcat
	read -p "Ripunk>: " choice 
    case $choice in
        1)
            select_twrp
	    # Periksa jika pengguna memilih berkas TWRP
	    if [ -z "$twrp_file" ]; then
  		show_error "Anda harus memilih berkas TWRP."
	    else
  	    # Pastikan perangkat Anda dalam mode Fastboot
  		fastboot devices 2>/dev/null 2>&1
  		if [ $? -eq 0 ]; then
    	    # Flash ROM menggunakan Fastboot
    			flash_twrp
    			
  		else
    			show_error "Perangkat Anda tidak dalam mode Fastboot atau tidak terhubung."
  		fi
	    fi
            ;;
        2)
            select_rom
	    # Periksa jika pengguna memilih berkas TWRP
	    if [ -z "$rom_file" ]; then
  		show_error "Anda harus memilih berkas ROM."
	    else
  	    # Pastikan perangkat Anda dalam mode Fastboot
  		fastboot devices 2>/dev/null 2>&1
  		if [ $? -eq 0 ]; then
    	    # Flash ROM menggunakan Fastboot
    			flash_rom
  		else
    			show_error "Perangkat Anda tidak dalam mode Fastboot atau tidak terhubung."
  		fi
	    fi

            ;;
        3)

      				dialog --title "INFO" --msgbox "Masih Dalam Tahap Pengembangan!" 10 40
            ;;
        4)

      				dialog --title "INFO" --msgbox "Masih Dalam Tahap Pengembangan!" 10 40
            ;;
        5)

      				dialog --title "INFO" --msgbox "Masih Dalam Tahap Pengembangan!" 10 40
            ;;
        6)
            clear
            echo "Exiting..."
            exit 0
            ;;
        *)
            clear
            echo "Pilihan Salah. Coba Lagi."
            sleep 2
            ;;
    esac
done
done
