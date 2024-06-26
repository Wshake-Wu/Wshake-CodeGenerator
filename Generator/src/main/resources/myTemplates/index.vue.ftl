<#assign moduleName="${dataBase.camelName}" />
<#assign pathName="${table.tableLowerName}" />
<#assign pkAttrname="${table.camelKeyName[0]}" />
<template>
    <el-card shadow="never" class="aui-card--fill">
        <div class="mod-${moduleName}__${pathName}}">
            <el-form :inline="true" :model="dataForm" @keyup.enter.native="getDataList()">
                <el-form-item>
                    <el-input v-model="dataForm.${pkAttrname}" placeholder="${pkAttrname}" clearable></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button @click="getDataList()">{{ $t('query') }}</el-button>
                </el-form-item>
                <el-form-item>
                    <el-button type="info" @click="exportHandle()">{{ $t('export') }}</el-button>
                </el-form-item>
                <el-form-item>
                    <el-button v-if="$hasPermission('${moduleName}:${pathName}:save')" type="primary" @click="addOrUpdateHandle()">{{ $t('add') }}</el-button>
                </el-form-item>
                <el-form-item>
                    <el-button v-if="$hasPermission('${moduleName}:${pathName}:delete')" type="danger" @click="deleteHandle()">{{ $t('deleteBatch') }}</el-button>
                </el-form-item>
            </el-form>
            <el-table v-loading="dataListLoading" :data="dataList" border @selection-change="dataListSelectionChangeHandle" style="width: 100%;">
                <el-table-column type="selection" header-align="center" align="center" width="50"></el-table-column>
                <#list table.columns as column>
                <el-table-column prop="${column.columnCamelName}" label="${column.comment}" header-align="center" align="center"></el-table-column>
                </#list>
                <el-table-column :label="$t('handle')" fixed="right" header-align="center" align="center" width="150">
                    <template slot-scope="scope">
                        <el-button v-if="$hasPermission('${moduleName}:${pathName}:update')" type="text" size="small" @click="addOrUpdateHandle(scope.row.id)">{{ $t('update') }}</el-button>
                        <el-button v-if="$hasPermission('${moduleName}:${pathName}:delete')" type="text" size="small" @click="deleteHandle(scope.row.id)">{{ $t('delete') }}</el-button>
                    </template>
                </el-table-column>
            </el-table>
            <el-pagination
                    :current-page="page"
                    :page-sizes="[10, 20, 50, 100]"
                    :page-size="limit"
                    :total="total"
                    layout="total, sizes, prev, pager, next, jumper"
                    @size-change="pageSizeChangeHandle"
                    @current-change="pageCurrentChangeHandle">
            </el-pagination>
            <!-- 弹窗, 新增 / 修改 -->
            <add-or-update v-if="addOrUpdateVisible" ref="addOrUpdate" @refreshDataList="getDataList"></add-or-update>
        </div>
    </el-card>
</template>

<script>
    import mixinViewModule from '@/mixins/view-module'
    import AddOrUpdate from './${pathName}-add-or-update'
    export default {
        mixins: [mixinViewModule],
        data () {
            return {
                mixinViewModuleOptions: {
                    getDataListURL: '/${moduleName}/${pathName}/page',
                    getDataListIsPage: true,
                    exportURL: '/${moduleName}/${pathName}/export',
                    deleteURL: '/${moduleName}/${pathName}',
                    deleteIsBatch: true
                },
                dataForm: {
                    ${pkAttrname}: ''
                }
            }
        },
        components: {
            AddOrUpdate
        }
    }
</script>
