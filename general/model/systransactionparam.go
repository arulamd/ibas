package model

import "time"

type SysTransactionParam struct {
	TranTypeCode          string     `gorm:"column:TRANTYPECODE;primaryKey" json:"tranTypeCode"`
	TranTypeName          string     `gorm:"column:TRANTYPENAME" json:"tranTypeName"`
	LastTransactionNo     *int64     `gorm:"column:LASTTRANSACTIONNO" json:"lastTransactionNo"`
	RecordLocked          string     `gorm:"column:RECORDLOCKED" json:"recordLocked"`
	LockedUserName        string     `gorm:"column:LOCKEDUSERNAME" json:"lockedUserName"`
	MaintainTransactionNo string     `gorm:"column:MAINTAINTRANSACTIONNO" json:"maintainTransactionNo"`
	TranYear              int        `gorm:"column:TRANYEAR" json:"tranYear"`
	UserAdd               string     `gorm:"column:USERADD" json:"userAdd"`
	DateAdd               *time.Time `gorm:"column:DATEADD" json:"dateAdd"`
	Sequence_Name         string     `gorm:"column:SEQUENCE_NAME" json:"Sequence_Name"`
	ID                    int64      `gorm:"column:ID" json:"id" example:"1001"`
	DivisionCode          string     `gorm:"column:DIVISIONCODE;primaryKey" json:"divisionCode" example:"DV001"`
	CompanyCode           string     `gorm:"column:COMPANYCODE;primaryKey" json:"companyCode" example:"CP001"`
}

// TableName overrides the default table name
func (SysTransactionParam) TableName() string {
	return "IBAS.SYSTRANSACTIONPARAM"
}
