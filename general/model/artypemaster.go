package model

import "time"

type ArTypeMaster struct {
	ArTypeCode            string     `gorm:"column:ARTYPECODE;primaryKey" json:"arTypeCode"`
	ArTypeName            string     `gorm:"column:ARTYPENAME" json:"arTypeName"`
	ArTypeGroup           int        `gorm:"column:ARTYPEGROUP" json:"arTypeGroup"`
	Priority              int        `gorm:"column:PRIORITY" json:"priority"`
	ArAccount             string     `gorm:"column:ARACCOUNT" json:"arAccount"`
	RevenueAccount        string     `gorm:"column:REVENUEACCOUNT" json:"revenueAccount"`
	UnEarnedRevAccount    string     `gorm:"column:UNEARNEDREVACCOUNT" json:"unEarnedRevAccount"`
	ArTypeClass           string     `gorm:"column:ARTYPECLASS" json:"arTypeClass"`
	Vatable               string     `gorm:"column:VATABLE" json:"vatable"`
	RequirePeriod         string     `gorm:"column:REQUIREPERIOD" json:"requirePeriod"`
	DiscountGlAccountCode string     `gorm:"column:DISCOUNTGLACCOUNTCODE" json:"discountGlAccountCode"`
	Isoc                  string     `gorm:"column:ISOC" json:"isoc"`
	ArGlAcctCode          string     `gorm:"column:ARGLACCTCODE" json:"arGlAcctCode"`
	ArTypeGlAcctCode      string     `gorm:"column:ARTYPEGLACCTCODE" json:"arTypeGlAcctCode"`
	ArTypeGlName          string     `gorm:"column:ARTYPEGLNAME" json:"arTypeGlName"`
	ErpRevAcctCode        string     `gorm:"column:ERPREVACCTCODE" json:"erpRevAcctCode"`
	ErpArAcctCode         string     `gorm:"column:ERPARACCTCODE" json:"erpArAcctCode"`
	ErpArTypeName         string     `gorm:"column:ERPARTYPENAME" json:"erpArTypeName"`
	ErpRevenueAccountName string     `gorm:"column:ERPREVENUEACCOUNTNAME" json:"erpRevenueAccountName"`
	BssArTypeCode         string     `gorm:"column:BSSARTYPECODE" json:"bssArTypeCode"`
	Ismrc                 string     `gorm:"column:ISMRC" json:"ismrc"`
	UserAdd               string     `gorm:"column:USERADD" json:"userAdd"`
	DateAdd               *time.Time `gorm:"column:DATEADD" json:"dateAdd"`
	ID                    int64      `gorm:"column:ID" json:"id" example:"1001"`
	DivisionCode          string     `gorm:"column:DIVISIONCODE;primaryKey" json:"divisionCode" example:"DV001"`
	CompanyCode           string     `gorm:"column:COMPANYCODE;primaryKey" json:"companyCode" example:"CP001"`
}

// TableName overrides the default table name
func (ArTypeMaster) TableName() string {
	return "IBAS.ARTYPEMASTER"
}
