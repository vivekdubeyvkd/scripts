# reference : https://community.synopsys.com/servlet/fileField?entityId=kaC2H000000kBAOUA2&field=Attachment__Body__s

##########################################################################################################
COV_PLATFORM_TARGET_INSTALLER_LOCATION='${mydir}/cov-platform-linux64-2021.12.2.sh'
EXISTING_COV_PLATFORM_INSTALLATION="${mydir}/existing-cov-installation-dir"
UPGRADE_COV_PLATFORM_INSTALLATION="${mydir}/upgrade-cov-installation-dir"
TEMP_BACKUP_LOCATION="${mydir}/backup-upgrade-prep"
COV_HOSTNAME="my.cov.com"
COV_LICENSE_DAT_FILE="${mydir}/license.dat"
##########################################################################################################

##########################################################################################################
chmod 755 ${COV_PLATFORM_TARGET_INSTALLER_LOCATION}
mkdir -p ${TEMP_BACKUP_LOCATION}
mkdir -p ${UPGRADE_COV_PLATFORM_INSTALLATION}
##########################################################################################################

##########################################################################################################
# Upgrade preparation =>
##########################################################################################################
${COV_PLATFORM_TARGET_INSTALLER_LOCATION} -q \
--install.type=4 \
--license.region=0 \
--license.agreement=agree \
--backup.dir=${TEMP_BACKUP_LOCATION} \
--existing.instance.dir=${EXISTING_COV_PLATFORM_INSTALLATION} 


##########################################################################################################
# Backup and restore  =>
##########################################################################################################
${COV_PLATFORM_TARGET_INSTALLER_LOCATION} -q \
--install.type=2 \
--license.region=0 \
--license.agreement=agree \
--license.path=${COV_LICENSE_DAT_FILE} \
--hostname=${COV_HOSTNAME} \
--existing.instance.dir=${EXISTING_COV_PLATFORM_INSTALLATION} \
--installation.dir=${UPGRADE_COV_PLATFORM_INSTALLATION} \
--backup.automated=false \
--backup.dir=${TEMP_BACKUP_LOCATION}
